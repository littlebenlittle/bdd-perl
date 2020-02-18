use strict;
use warnings;

package Grammar::Gherkin::Model::Scenario;

sub new {
  my ($class, $line) = @_;
  my $self = {
    name        => $line,
    description => '',
    steps       => [],
  };
  bless $self, $class;
}

1;

