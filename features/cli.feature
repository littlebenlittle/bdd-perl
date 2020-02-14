
Feature: CLI
  In order to run behavioral tests on cli apps
  as a developer
  I need a scriptable cli tool

  Background:
    Given there is a file "example.feature" containing
    """
    Feature: Passing and Failing Scenarios
      @failing
      Scenario: Wrong exit code
        When I run "sh -c 'exit 0'"
        Then the process returns a non-zero exit code
      @passing
      Scenario: Right exit code
        When I run "sh -c 'exit 1'"
        Then the process returns a non-zero exit code
      @undefined
      Scenario: Undefined steps
        Given I am a unicorn
        When  I shoot rainbows
        Then  there should be glitter everywhere
    """

  Scenario: Tests fail
    When  I run "btest --tags @failing example.feature"
    Then  the process returns a non-zero exit code

  Scenario: Tests pass
    When  I change directory to "test_fixtures"
    And   I run "btest --tags @passing"
    Then  the process returns exit code 0

  Scenario: Missing step definitions
    When  I change directory to "test_fixtures/missing_steps"
    And   I run "btest --tags @undefined "
    Then  the process returns a non-zero exit code
    And   I should see
    """
    You are missing step definitions for:
    Given I am a unicorn
    When  I shoot rainbows
    Then  there should be glitter everywhere
    """

  
