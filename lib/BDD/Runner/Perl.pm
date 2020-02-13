use strict;
use warnings;
use 5.10.0;

package BDD::Runner::Perl;
use parent 'BDD::Runner';

sub new {
    my $self = BDD::Runner->new;
    bless $self, shift;
}

sub load {
    my ($self, $step_file) = @_;
    die unless eval { require $step_file; };
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

