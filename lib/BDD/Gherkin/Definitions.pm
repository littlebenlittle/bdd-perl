use strict;
use warnings;

package BDD::Gherkin::Definitions;

sub new {
    my ($class, $definitions, $runner) = @_;
    my $self = {};
    $self->{runner} = $runner;
    $runner->load( $_ ) for @$definitions;
    bless $self, $class;
}

sub match {
}

1;

