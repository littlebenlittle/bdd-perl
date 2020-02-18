
use strict;
use warnings;
use 5.10.0;

use Test::More;
use Test::Exception;
use File::Temp qw( tempdir );

use Grammar::Gherkin::Parser;

my $dirname = tempdir();
my $feature_filepath = $dirname . '/example.feature';

exit 1;

