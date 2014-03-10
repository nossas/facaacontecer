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



  Scenario: A new user subscribe with credit card info in the subscription form
    Given I am in the root path 
    And I click on Contribua!
    And I fill in Nome with "Homer"
    And I fill in Sobrenome with "Simpson"
    And I fill in CPF with "11111111111"
    And I fill in Data de nascimento with "12/11/1988"
    And I fill in Email with "homer@simpson.com"
    And I fill in Telefone with "(21) 99999-9999"
    #And I choose an annual subscription of "R$ 20 por mês"
    #And I choose "Cartão de Crédito" for "Qual a forma de pagamento?"
    And I fill in CEP with "22222-080"
    And I fill in Endereço with "Rua Exemplo 201, Ap. 204"
    And I fill in Número with "306"
    And I fill in Complemento with "Ap 204"
    And I fill in Bairro with "Mister Bruns"
    And I fill in Cidade with "Rio de Janeiro"
    #And I select "RJ" for "Estado"
    When I click on Contribuir!
    Then I should see "Aguarde, estamos processando seu pagamento"
    And I should see 1 subscription in the database
    And I should see 1 user in the database

