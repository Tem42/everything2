package Everything::APIClient;

use Moose;
use LWP::UserAgent;
use HTTP::Cookies;
use HTTP::Request;
use namespace::autoclean;
use JSON;

with 'Everything::HTTP';

has 'ua' => (is => 'ro', isa => 'LWP::UserAgent', lazy => 1, builder => "_build_ua", handles => ["get"]);
has 'session' => (is => 'rw', isa => 'HashRef', lazy => 1, builder => "_build_session");
has 'endpoint' => (is => 'ro', required => 1, default => "https://everything2.com/api");
has 'json' => (is => 'ro', lazy => 1, builder => "_build_json");

sub username
{
  my ($self) = @_;
  if($self->session->{display}->{is_guest} == 0)
  {
    return $self->session->{user}->{title};
  }else{
    return "Guest User";
  }
}

sub _build_json
{
  my ($self) = @_;
  return JSON->new();
}

sub _build_ua
{
  my ($self) = @_;
  my $cookies = HTTP::Cookies->new();
  my $ua = LWP::UserAgent->new();
  $ua->cookie_jar($cookies);

  return $ua;
}

sub _build_session
{
  my ($self) = @_;
  my $response = $self->get($self->endpoint."/sessions");
  if($response->code == $self->HTTP_OK)
  {
    $self->session($self->json->decode($response->content));
  }
}

sub login
{
  my ($self, $username, $passwd) = @_;

  # This is intentionally so we can test for bad requests
  my $postdata;
  $postdata->{username} = $username if $username;
  $postdata->{passwd} = $passwd if $passwd;

  return $self->_format_response($self->_do_post($self->endpoint."/sessions/create", $postdata), "session");
}

sub _do_post
{
  my ($self, $location, $postdata) = @_;

  my $request = HTTP::Request->new("POST", $location);
  $request->header('Content-Type' => 'application/json');
  $request->content($self->json->encode($postdata));
  return $self->ua->request($request);
}

sub logout
{
  my ($self) = @_;

  my $response = $self->get($self->endpoint."/sessions/delete");
  $self->session($self->json->decode($response->content));
  return $self->_format_response($response, "session");
}

sub messages
{
  my ($self, $limit, $offset) = @_;

  my $query_string = "";
  $query_string .= "limit=$limit;" if $limit;
  $query_string .= "offset=$offset;" if $offset;
  $query_string = "?$query_string" if $query_string;

  $self->_format_response($self->get($self->endpoint."/messages$query_string"), "messages");

}

sub message_id
{
  my($self, $message_id) = @_;

  $self->_format_response($self->get($self->endpoint."/messages/$message_id"),"message");

}

sub send_message
{
  my ($self, $for, $message) = @_;
  $self->_format_response($self->_do_post($self->endpoint."/messages/create", {"for" => $for, "message" => $message}),"message");
}

sub _format_response
{
  my ($self, $response, $data_key) = @_;

  $data_key ||= "data";
  my $output = {"code" => $response->code};
  
  if($response->code == $self->HTTP_OK)
  {
    $output->{$data_key} = $self->json->decode($response->content);
  }

  return $output;
}

sub get_ignores
{
  my ($self) = @_;
  $self->_format_response($self->get($self->endpoint."/messageignores"), "messageignore");
}

sub ignore_messages_from
{
  my ($self, $ignore) = @_;

  $self->_format_response($self->_do_post($self->endpoint."/messageignores/create", {"ignore" => $ignore}),"messageignore");
}

sub ignore_messages_from_id
{
  my ($self, $ignore) = @_;
  
  $self->_format_response($self->_do_post($self->endpoint."/messageignores/create", {"ignore_id" => $ignore}),"messageignore");
}

sub unignore_messages_from_id
{
  my ($self, $ignore_id) = @_;

  $self->_format_response($self->ua->get($self->endpoint."/messageignores/$ignore_id/action/delete"),"messageignore");
}

sub create_e2node
{
  my ($self, $data) = @_;
  
  $self->_format_response($self->_do_post($self->endpoint."/e2nodes/create", $data),"e2node");
}

sub create_usergroup
{
  my ($self, $data) = @_;
  
  $self->_format_response($self->_do_post($self->endpoint."/usergroups/create", $data),"usergroup");
}

sub usergroup_add
{
  my ($self, $group_id, $user_ids) = @_;

  $self->_format_response($self->_do_post($self->endpoint."/usergroups/$group_id/action/adduser", $user_ids));
}

sub usergroup_remove
{
  my ($self, $group_id, $user_ids) = @_;

  $self->_format_response($self->_do_post($self->endpoint."/usergroups/$group_id/action/removeuser",$user_ids));
}

sub delete_node
{
  my ($self, $node_id) = @_;
  $self->_format_response($self->ua->get($self->endpoint."/nodes/$node_id/action/delete"));
}

sub get_node_by_id
{
  my ($self, $node_id) = @_;
  $self->_format_response($self->ua->get($self->endpoint."/nodes/$node_id"));
}

sub get_node
{
  my ($self, $title, $type) = @_;
  $self->_format_response($self->ua->get($self->endpoint."/nodes/lookup/$type/$title"));
}

1;