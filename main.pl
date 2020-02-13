use strict;
use warnings;
use 5.10.0;

use Grammar::Gherkin::Parser;
use BDD::Runner::Perl;

my $filepath = shift;
die 'No filepath supplied' if not $filepath;
my $definitions = [ '/usr/src/bdd/magical_example.pl' ];
my $runner = BDD::Runner::Perl->get_runner;
$runner->load( $_ ) for @$definitions;
my $parser = Grammar::Gherkin::Parser->new( $runner );
$parser->parse($filepath);

