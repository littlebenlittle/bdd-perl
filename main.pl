use strict;
use warnings;

use Grammar::Parser::Gherkin::Lite;

my $filepath = shift;
die 'No filepath supplied' if not $filepath;
my $parser = Grammar::Parser::Gherkin::Lite->new();
$parser->parse($filepath);

