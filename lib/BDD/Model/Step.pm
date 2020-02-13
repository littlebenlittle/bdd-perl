use strict;
use warnings;

package BDD::Model::Step;

sub new {
    my ($class, $handler, $regex, $arg) = @_;
    my $self = {
        handler => $handler,
        regex   => $regex,
        arg     => $arg,
    };
    bless $self, $class;
}

sub run {
    my $self = shift;
    $self->{arg} =~ m/$self->{regex}/;
    &{ $self->{handler} };
}

1;

