#!/usr/bin/env perl

use strict;
use lib qw(/var/libraries/lib/perl5);
use lib qw(/var/everything/ecore);
use Everything;
use Everything::S3;
use JSON;
use Paws;

sub http_response
{
  my ($code, $message) = @_;
  return JSON->new->encode({
    "statusCode" => $code,
    "headers" => {"Content-Type" => "application/json"},
    "body" => {"message" => $message}});
}

sub lambda_handler
{
  my ($event) = @_;

  print "Initializing Everything Engine\n";
  initEverything 'everything';

  my $lambda = Paws->service('Lambda', 'region' => $Everything::CONF->current_region);
  my $s3 = Everything::S3->new("sitemapdispatch");

  my $current_batch = 1;
  my $batches = $APP->sitemap_batches;
  foreach my $batch(@$batches)
  {
    print "Uploading batch: $current_batch.json\n";
    $s3->upload_data("$current_batch.json", JSON->new->utf8->encode($batch), {"content_type" => "application/json"});
    print "Upload done: $current_batch.json\n";

    $lambda->Invoke('FunctionName' => 'sitemap-batch-processor', 'InvocationType' => 'Event', 'Payload' => JSON->new->utf8->encode({"batch" => $current_batch}));
    $current_batch++;
  }

  http_response(200, "OK");
}

1;
