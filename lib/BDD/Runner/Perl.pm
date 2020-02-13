use strict;
use warnings;
use 5.10.0;

package BDD::Runner::Perl;
use parent 'BDD::Runner';

sub get_runner {
    my $class = shift;
    my $self = BDD::Runner->get_runner;
    bless $self, $class;
}

sub load {
    die unless eval { require $_; };
}

sub register {
    my ($kw, $regex, $handler) = @_;
    my $runner = BDD::Runner::Perl->get_runner;
    push @{ $runner->{steps} }, {
        kw      => $kw,
        regex   => $regex,
        handler => $handler,
    };
}

1;

