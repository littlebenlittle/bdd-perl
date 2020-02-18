use strict;
use warnings;
use 5.10.0;

use Test::More;
use Test::Exception;
use Util qw( get_files );

use BDD::Perl::Runner;

my $runner = BDD::Perl::Runner->get_instance;

is_deeply $runner, BDD::Perl::Runner->get_instance,
'Perl Runner is a singleton';

throws_ok { $runner->run('') } qr/Runner has no registered definitions/,
'Cannot run anything on a runner with no registered definitions';

$runner->register(qr/SAYOK/, sub { 'OK'; });
throws_ok { $runner->run('') } qr/No match found for .*/,
'Cannot run an arg with no matching definition';

is $runner->run('SAYOK'), 'OK',
'Can run an arg with matching definition and get expected result';

ok(not ($runner->can_run('No matching definitions')),
'Step without matching definition cannot be run');

$runner->register(qr/ECHO (.*)/, sub { $1; });
is $runner->run('ECHO my argument'), 'my argument',
'Runner can return arg from regex match';

$runner->register(qr/TWO (.*) are some (.*)/, sub { $1 . $2; });
is $runner->run('TWO here are some things'), 'herethings',
'Runner can return TWO args from regex match';

isnt($runner->{ctx}, undef,
'Runner has a defined context');

$runner->register(qr/CONTEXT/, sub { $runner->{ctx}->{somedata}; });
$runner->{ctx}->{somedata} = 'my data';
is $runner->run('CONTEXT'), 'my data',
'Step definitions can access runner\'s context';

done_testing();

