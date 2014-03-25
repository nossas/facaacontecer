Feature: Show that my payment was created or not
  In order to collaborate using payment options
  as an user
  I want to see a message that my payment was created

  Background: 
    Given the following project:
      | title | Projeto |
      | goal  | 450000  |
      | description | New desc | 
      | expiration_date | 22/10/2020 |


  @vcr
  Scenario Outline: A user subscribes using boleto
    Given I am in the root path 
    And I click on Contribuir!
    And I subscribe using <payment>
    And I should see "<waiting_message>"
    And the subscription status should be <status>
    When I reload the subscription page
    Then I should see <count> payments in the database
    And the subscription status should be <final_status>
    And I should see "<final_message>"
    And I should see the subscription <payment> url
    Examples:
      |count | payment | status      | final_status | waiting_message                                    | final_message |
      |1     | boleto  | processing  | waiting      | Aguarde, estamos gerando o link para o seu boleto. | obrigado por fazer o Meu Rio acontecer           |      




