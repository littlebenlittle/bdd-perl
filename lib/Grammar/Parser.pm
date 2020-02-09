use strict;
use warnings;
use 5.10.1;

package Grammar::Parser;

sub new {
  my $class = shift;
  return bless {}, $class;
}

sub register {
  my ($self, $state, $handler) = @_;
  say $state;
}

sub parse {
  my ($self, $filepath) = @_;
  open my $fh, '<', $filepath or die $! . " $filepath";
  while ( <$fh> ) {
    chomp;
    say;
  }
}

1;

