Feature: Cumuli exits the app gracefully
  In order to use Cumuli to test in an integration way, a suite of apps and services
  As a developer with a SOA stack
  I want cucumber to exit with a good success code

  Background:
    Given the app suite is loaded

  Scenario: App is stopped in a cucumber step
    When I shutdown the app suite
    Then the processes should not be running
    And I should see that the rake was not aborted

  #Scenario: App's forked pid receives an INT signal
    #When the forked pid receives an INT signal
    #Then the processes should not be running
    #And I should see that the rake was not aborted

  Scenario: App's forked pid receives a KILL signal
    When the forked pid receives an KILL signal
    Then the processes should not be running
    And I should see that the rake was not aborted

  Scenario: App's forked pid receives a TERM signal
    When the forked pid receives an TERM signal
    Then the processes should not be running
    And I should see that the rake was not aborted
