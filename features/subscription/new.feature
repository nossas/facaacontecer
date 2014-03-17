Feature: New subscription for the current campaign
  In order to subscribe to Meu Rio Crowdfunding platform
  as an user
  I want to choose a subscription plan to apply to


  Background: 
    Given the following project:
      | title | Projeto |
      | goal  | 450000  |
      | description | New desc | 
      | expiration_date | 22/10/2020 |

  Scenario: Visiting the new subscription page
    Given I am in the root path
    When I click on Contribua!
    Then I should see "Insira seus dados pessoais"



  Scenario Outline: A new user subscribe with credit card info in the subscription form
    Given I am in the root path 
    And I click on Contribua!
    And I fill in Nome with "<first_name>"
    And I fill in Sobrenome with "<last_name>"
    And I fill in CPF with "<cpf>"
    And I fill in Data de nascimento with "<birthday>"
    And I fill in Email with "<email>"
    And I fill in Telefone with "<phone>"
    And I choose an "<interval>" subscription of "<value>"
    And I choose "<payment_option>" for "Qual a forma de pagamento?"
    And I fill in CEP with "<zipcode>"
    And I fill in Endereço with "<street>"
    And I fill in Número with "<number>"
    And I fill in Complemento with "<extra>"
    And I fill in Bairro with "<district>"
    And I fill in Cidade with "<city>"
    And I select "<state>" for "Estado"
    When I click on Contribuir!
    Then I should see "<message>"
    And I should see <count> subscriptions in the database
    And I should see <count> users in the database
    And the subscription status should be <status>
    
    Examples:
      | count | status | message                | first_name | last_name | cpf            | birthday   | email            |phone | interval | value | payment_option | zipcode | street | number | extra | district | city | state |
      | 1     | active | não é um email válido  | Luiz       | Fonseca   | 919.133.769-07 | 12/11/1988 | emailemail.com | (21) 99999-9999 | monthly | R$ 30 | Cartão de Crédito | 22222-222 | Rua | 300 | Ape | Botafogo | Rio de Janeiro | RJ  |
      | 1     | active | CPFnão é válido        | Luiz       | Fonseca   | 919.133.111-17 | 12/11/1988 | email@email.com | (21) 99999-9999 | monthly | R$ 30 | Cartão de Crédito | 22222-222 | Rua | 300 | Ape | Botafogo | Rio de Janeiro | RJ  |
      | 1     | active | Aguarde!               | Luiz       | Fonseca   | 919.133.769-07 | 12/11/1988 | email@email.com | (21) 99999-9999 | monthly | R$ 30 | Cartão de Crédito | 22222-222 | Rua | 300 | Ape | Botafogo | Rio de Janeiro | RJ  |
