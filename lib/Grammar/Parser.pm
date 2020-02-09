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

sub register {
  my ($self, $state, $handler) = @_;
  $self->{handlers}->{$state} = $handler;
}

sub parse {
  my ($self, $filepath) = @_;
  open my $fh, '<', $filepath
    or die "Cannot open $filepath: $!";
  my $state = $self->{init_state};
  my $ctx   = {
    undefined => [],
  };
  while ( <$fh> ) {
    print $_;
    $state = $self->{handlers}->{$state}( $ctx, $_ );
    print $state . '|';
  }
}

1;

