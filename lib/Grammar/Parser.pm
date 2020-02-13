use strict;
use warnings;

package Grammar::Parser;

sub new {
    my ($class, $init_state) = @_;
    bless {
        init_state => $init_state,
        handlers   => {},
    }, $class;
}

sub register_init {
    my ($self, $state, $handler) = @_;
    $self->{init_state} = $state;
    $self->register($state, $handler);
}

sub register {
    my ($self, $state, $handler) = @_;
    $self->{handlers}->{$state} = $handler;
}

sub before {}

sub after {}

sub parse {
    my ($self, $filepath) = @_;
    open my $fh, '<', $filepath
      or die "Cannot open $filepath: $!";
    my $state = $self->{init_state};
    my $ctx   = {};
    $self->before( $ctx );
    while ( <$fh> ) {
        chomp;
        my $handler = $self->{handlers}->{$state};
        die "Unregistered state: $state"
          unless $handler;
        my $next_state = &$handler( $ctx, $_ );
        die "No state returned by handler for \"$state\" with input \"$_\""
          unless $next_state;
        $state = $next_state;
    }
    $self->after( $ctx );
}

1;

