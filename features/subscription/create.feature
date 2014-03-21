Feature: Show that my payment was created or not
  In order to collaborate using payment options
  as an user
  I want to see a message that my payment was created




  Scenario Outline: A user subscribes using boleto|debit
    Given I subscribed using <payment>
    And I'm in the edit subscriber path
    And I should see "<waiting_message>"
    And the subscription status should be <status>
    When I reload the page after 5 seconds
    Then I should be on the subscriber_path
    And I should see <final_message>
    And I should see the subscription <payment> url
    Examples:
      | payment | status | waiting_message | final_message |




