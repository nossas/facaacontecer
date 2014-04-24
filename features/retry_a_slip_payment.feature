# TODO this should be a temporary approach for the users to retry their payments

Feature: retry a slip payment

  Scenario: when the payment exists
    Given 1 payment
    When I go to "this payment retry page"
    Then I should be in "this payment subscription page"
