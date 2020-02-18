use strict;
use warnings;

package Grammar::Gherkin::Model::Feature;

sub new {
  my ($class, $line) = @_;
  my $self = {
    name        => $line,
    description => '',
    background  => undef,
    scenarios   => [],
  };
  bless $self, $class;
}

1;

