use strict;
use warnings;
use 5.10.0;

use Test::More;
use Util qw( get_files );

my @files = get_files '/work/tmp/';
ok grep {/parser\.txt/} @files, 'file exists';
ok not grep {/bish\.boombash/} @files, 'file does not exist';
done_testing();

