
use strict;
use warnings;
use 5.10.0;

use Test::More;
use Test::Exception;
use Util qw( write_to_temp_file  );

use Grammar::Gherkin::Parser;

my $feature_file = write_to_temp_file <<EOF;
Feature: Some Feature

  Scenario: A scenario block
    Given I am a unicorn
    When  I shoot rainbows
    Then  there is glitter everywhere
EOF
my $parser = Grammar::Gherkin::Parser->new;
ok( @{ $parser->{features} } == 0, 'Parser has no features before parsing');
$parser->parse( $feature_file );
ok( @{ $parser->{features} } != 0, 'Parser detected a feature');

done_testing();

