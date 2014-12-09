Feature: New subscription for the current campaign
  In order to subscribe to Meu Rio Crowdfunding platform
  as an user
  I want to choose a subscription plan to apply to


  Background:
    Given the following organization:
      | name              | Meu Rio |
      | mailchimp_list_id | 123 |
    Given the following project:
      | title | Projeto |
      | goal  | 450000  |
      | description | New desc |
      | expiration_date | 22/10/2020 |


  Scenario: Visiting the new subscription page
    Given I am in the root path
    When I click on Contribua!
    Then I should see "Dados Pessoais"


  @vcr
  Scenario Outline: A new user subscribe with DEBIT OR SLIP info in the subscription form
    Given I am in the root path
    And I click on Contribua!
    And I fill in Nome with "<first_name>"
    And I fill in Sobrenome with "<last_name>"
    And I fill in CPF with "<cpf>"
    And I fill in Data de nascimento with "<birthday>"
    And I fill in Email with "<email>"
    And I fill in Celular with "<phone>"
    And I choose "Meu Rio" for "Organization"
    And I choose "<value>" for "Qual o valor?"
    And I choose "<payment_option>" for "Qual a forma de pagamento?"
    And I choose "<bank>" for "Qual seu banco?"
    And I choose "<interval>" for "Frequência de pagamento"
    And I fill in CEP with "<zipcode>"
    And I fill in Endereço with "<street>"
    And I fill in Número with "<number>"
    And I fill in Complemento with "<extra>"
    And I fill in Bairro with "<district>"
    And I fill in Cidade with "<city>"
    And I select "<state>" for "Estado"
    When I click on Contribuir!
    Then the subscription status should be <status>
    And I should see "<message>"
    And I should see <count> subscriptions in the database
    And I should see <count> users in the database

    Examples:
      | count | status      | message                                             | first_name | last_name | cpf            | birthday   | email            |phone | interval         | value | payment_option    | bank | zipcode | street | number | extra | district | city | state |
      | 0     |             | não é um email válido                               | Luiz       | Fonseca   | 919.133.769-07 | 12/11/1988 | emailemail.com | (21) 999999999 | Mensal  | R$ 30 | Cartão de Crédito | Itaú | 22222-222 | Rua | 300 | Ape | Botafogo | Rio de Janeiro | RJ  |
      | 0     |             | CPFnão é válido                                     | Luiz       | Fonseca   | 919.133.111-17 | 12/11/1988 | email@email.com | (21) 999999999 | Mensal | R$ 30 | Cartão de Crédito | Itaú | 22222-222 | Rua | 300 | Ape | Botafogo | Rio de Janeiro | RJ  |
      | 1     | processing  | Aguarde só um instantinho enquanto processamos o seu pagamento           | Luiz       | Fonseca   | 919.133.769-07 | 12/11/1988 | email@email.com | (21) 999999999 | Mensal | R$ 30 | Cartão de Crédito | Itaú | 22222-222 | Rua | 300 | Ape | Botafogo | Rio de Janeiro | RJ  |
      | 1     | processing  | Aguarde só um instantinho enquanto geramos o link para o seu banco   | Luiz       | Fonseca   | 919.133.769-07 | 12/11/1988 | email@email.com | (21) 999999999 | Única      | R$ 90 | Débito            | Itaú | 22222-222 | Rua | 300 | Ape | Botafogo | Rio de Janeiro | RJ  |
      | 1     | processing  | Aguarde só um instantinho enquanto geramos o link para o seu boleto  | Luiz       | Fonseca   | 919.133.769-07 | 12/11/1988 | email@email.com | (21) 999999999 | Semestral  | R$ 90 | Boleto            | Itaú | 22222-222 | Rua | 300 | Ape | Botafogo | Rio de Janeiro | RJ  |
