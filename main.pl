use strict;
use warnings;

use Grammar::Gherkin::Parser;

my $filepath = shift;
die 'No filepath supplied' if not $filepath;
my $definitions = [ 'magical_example.pl' ];
my $parser = Grammar::Gherkin::Parser->new( $definitions );
$parser->parse($filepath);

