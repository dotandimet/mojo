use Mojo::Base -strict;
use Test::More;

plan skip_all => "Role::Tiny required for roles" unless Mojo::Base->can_roles;

# First test derived from sri's comment here:
# https://github.com/kraih/mojo/pull/1118#issuecomment-320930345
# TODO: make this a subtest

package Test::Mojo::Role::Location;

use Role::Tiny;
use Test::More; # for is()

sub location_is {
  my ($t, $value, $desc) = @_;
  $desc ||= "Location: $value";
  local $Test::Builder::Level = $Test::Builder::Level + 1;
  return $t->success(is($t->tx->res->headers->location, $value, $desc));
}

1;

package main;

use Test::Mojo;

plan tests => 3;

my $t = Test::Mojo->with_roles('Test::Mojo::Role::Location')->new();
$t->get_ok('http://mojolicio.us')
  ->status_is(301)
  ->location_is('http://mojolicious.org/')
  ->or(sub { diag 'doh!' });
