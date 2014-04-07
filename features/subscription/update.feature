Feature: Existing subscription for the current campaign
  In order to subscribe to Meu Rio Crowdfunding platform
  as an user
  I want to choose a subscription plan to apply to


  Background: 
    Given the following user:
      | email | this@user.com |
    Given the following project:
      | title | Projeto |
      | goal  | 450000  |
      | description | New desc | 
      | expiration_date | 22/10/2020 |




  @vcr
  Scenario Outline: An Existing user subscribe with credit card info in the subscription form
    Given I am in the root path 
    And I click on Contribua!
    And I fill in Nome with "<first_name>"
    And I fill in Sobrenome with "<last_name>"
    And I fill in CPF with "<cpf>"
    And I fill in Data de nascimento with "<birthday>"
    And I fill in Email with "<email>"
    And I fill in Celular with "<phone>"
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
    And I should see <sub_count> subscriptions in the database
    And I should see <count> users in the database
    
    Examples:
      | count | sub_count | status     | message                                             | first_name | last_name | cpf            | birthday   | email            |phone | interval         | value | payment_option    | bank | zipcode | street | number | extra | district | city | state |
      | 1     |   1       | processing | Aguarde só um instantinho enquanto geramos o link para o seu banco   | Luiz       | Fonseca   | 919.133.769-07 | 12/11/1988 | this@user.com | (21) 99999-9999 | Anual      | R$ 90 | Débito            | Itaú | 22222-222 | Rua | 300 | Ape | Botafogo | Rio de Janeiro | RJ  |
      | 2     |   1       | processing | Aguarde só um instantinho enquanto geramos o link para o seu boleto  | Luiz       | Fonseca   | 919.133.769-07 | 12/11/1988 | email@email.com | (21) 99999-9999 | Semestral  | R$ 90 | Boleto            | Itaú | 22222-222 | Rua | 300 | Ape | Botafogo | Rio de Janeiro | RJ  |

