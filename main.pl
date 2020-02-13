use strict;
use warnings;
use 5.10.0;

use Grammar::Gherkin::Parser;
use BDD::Runner::Perl;

use Cwd;

my $feature_dir = getcwd . '/features/';
my $step_dir = $feature_dir . 'step_definitions/';
my $runner = BDD::Runner::Perl->new;
opendir my $dh, $step_dir or die "Can't open dir $step_dir: $!";
while (readdir $dh) {
    next if $_ =~ m/^\.$/;
    my $step_file = $step_dir . $_;
    $runner->load( $step_file );
}
closedir $dh;

