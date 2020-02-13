use strict;
use warnings;
use 5.10.0;

package BDD::Runner::Perl;
use parent 'BDD::Runner';

my $singleton;

sub runner {
    $singleton = bless BDD::Runner->new, shift
      unless $singleton;
    return $singleton;
}

sub load {
    my ($self, $step_file) = @_;
    die unless eval { require $step_file; };
}

sub register {
    my ($self, $kw, $regex, $handler) = @_;
    push @{ $self->{steps} }, {
        kw      => $kw,
        regex   => $regex,
        handler => $handler,
    };
}

1;

