use strict;
use warnings;
use 5.10.0;

package BDD::Runner;
use BDD::Model::Step;

sub new {
    bless { steps => [] }, shift;
}

sub run {
    die '"run" not implemented in for ' . ref shift;
}

sub register {
    die '"register" not implemented for' . ref shift;
}

sub compile_step {
    my ($self, $kw, $arg) = @_;
    for (@{ $self->{steps} }) {
        return BDD::Model::Step->new( $_->{handler}, $_->{regex}, $arg )
          if $kw  eq $_->{kw}
            and $arg =~ m/$_->{regex}/;
    }
}

1; 

