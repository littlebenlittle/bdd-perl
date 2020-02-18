use strict;
use warnings;
use 5.10.0;

use Test::More;
use Util qw( get_files );

use BDD::Runner::Perl;
use Grammar::Gherkin::Model::Step;

my $runner = BDD::Runner::Perl->get_instance;

do {
    my $name = 'Perl Runner is a singleton';
    my $runnerB = BDD::Runner::Perl->get_instance;
    is_deeply $runner, $runnerB, $name;
};

do {
    $runner->register(qr/This is a step/, sub {
        "OK";
    });
    my $step = Grammar::Gherkin::Model::Step->new( 'This is a step' );
    my $step_binding = $runner->compile_step( $step );
    ok defined $step, 'Basic step match';
    is $step_binding->run, "OK", 'Can run step';
};

do {
    my $name = 'Step without matching definition cannot be compiled';
    my $step = Grammar::Gherkin::Model::Step->new( 'This is not a step' );
    my $step_binding = $runner->compile_step( $step );
    ok not (defined $step_binding), $name;
};

do {
    my $name = 'Step match with regex';
    $runner->register(qr/fruit: (.*)/, sub {
        $1;
    });
    my $step = Grammar::Gherkin::Model::Step->new( 'fruit: orange' );
    my $step_binding = $runner->compile_step( $step );
    ok defined $step, $name;
};

do {
    my $name = 'Run definition using arg from regex match';
    my $step = Grammar::Gherkin::Model::Step->new( 'fruit: orange' );
    my $step_binding = $runner->compile_step( $step );
    is $step_binding->run, "orange", $name;
};

do {
    my $name = 'Step definitions can access the context object';
    $runner->{ctx}->{data} = 'OK';
    $runner->register('BEGIN', qr/.*/, sub {
        my $ctx = shift;
        $ctx->{data};

    });
};

done_testing();

