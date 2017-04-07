#!/usr/bin/perl -w

use strict;
use lib qw(/var/everything/ecore);

use LWP::UserAgent;
use HTTP::Request;
use Test::More;
use Everything;
use JSON;

initEverything 'everything';
unless($APP->inDevEnvironment())
{
        plan skip_all => "Not in the development environment";
        exit;
}

my $endpoint = "http://localhost/api/sessions";
my $json = JSON->new;

ok(my $ua = LWP::UserAgent->new, "Make a new LWP::UserAgent object");
ok(my $response = $ua->get($endpoint), "Get the default sessions endpoint");
ok($response->code == 200, "Default sessions endpoint always returns 200");
ok(my $session = $json->decode($response->content), "Content accurately decodes");
ok($session->{username} eq "Guest User", "Username says 'Guest User'");
ok($session->{user_id} eq $Everything::CONF->guest_user, "User id is present and is that of Guest User");
ok($session->{is_guest} == 1, "is_guest should be on");
ok($response->header('content-type') =~ /^application\/json/i, "Returns JSON");

# Development credentials
ok(my $request = HTTP::Request->new("POST","$endpoint/create"), "Construct HTTP::Request object");
$request->header('Content-Type' => 'application/json');
$request->content($json->encode({"username" => "root","passwd" => "blah"}));
ok($response = $ua->request($request), "Good root credential POST to /create");
ok($response->code == 200);
ok($response->header('content-type') =~ /^application\/json/i, "Returns JSON");
ok(defined($response->header('set-cookie')), "Properly sets cookie header");
ok($session = $json->decode($response->content), "Content accurately decodes");
ok($session->{is_guest} == 0, "Accurately is not guest");
ok($session->{username} eq "root", "Logged in as root");

$request->content($json->encode({"username" => "normaluser1", "passwd" => "blah"}));
ok($response = $ua->request($request), "Good normaluser1 credential POST to /create");
ok($response->code == 200);
ok($response->header('content-type') =~ /^application\/json/i, "Returns JSON");
ok($session = $json->decode($response->content), "Content accurately decodes");
ok($session->{is_guest} == 0, "Accurately is not guest");
ok($session->{username} eq "normaluser1", "Logged in as normaluser1");
ok(defined($response->header('set-cookie')), "Properly sets cookie header");

done_testing();
