use strict;
use warnings;
use 5.10.0;

use Grammar::Gherkin::Parser;
use BDD::Runner::Perl;

use Cwd;
use Util qw( get_files );

my $feature_dir = getcwd . '/features/';
my $step_dir = $feature_dir . 'step_definitions/';
my $runner = BDD::Runner::Perl->new;
my $parser = Grammar::Gherkin::Parser->new;

for (get_files $step_dir) {
    next unless $_ =~ m/^\w\w*\.pl$/;
    $runner->load( $step_dir . $_ );
}
for (get_files $feature_dir) {
    next unless $_ =~ m/^\w\w*\.feature$/;
    $parser->parse( $feature_dir . $_ );
}

my @features = @{ $parser->{features} };
die "No feature files found in $feature_dir"
  if @features == 0;
runner->run_feature( $_ ) for @features;

