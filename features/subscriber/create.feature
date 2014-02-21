Feature: Subscribe to a project 
  In order to donate to the project
  as an user
  I want to subscribe to the project


  Background:
    Given the following project:
      | title           | Faça Acontecer |

  @javascript 
  Scenario Outline: A non existing user tries to subscribe
    Given I am in the root path
    And I fill in Nome with "<first>"
    And I fill in Sobrenome with "<last>"
    And I fill in Data de nascimento with "<date>"
    And I fill in Email with "<email>"
    And I fill in CPF with "<cpf>"
    And I fill in Celular with "<phone>"
    When I click on Continuar
    Then I should see "<message>"

    # INput mask doesn't allow the use of special chars like . / \ -
    Examples:
      | first | last    | date      | email       | cpf            | phone          | message |
      | luiz  | fonseca | 12111980  | test@test.com | 14606243430 | 21999998888 | CEP  |
      | luiz  |         | 12111980  | test@test.com | 14606243430 | 21999998888 | This value is required |

  @javascript
  Scenario Outline: A existing user tries to subscribe
    Given I am in the root path
    And there is a registered user with email: <email> and cpf: <cpf>
    And I fill in Nome with "<first>"
    And I fill in Sobrenome with "<last>"
    And I fill in Data de nascimento with "<date>"
    And I fill in Email with "<email>"
    And I fill in CPF with "<cpf>"
    And I fill in Celular with "<phone>"
    When I click on Continuar
    Then I should not see "<message>"

    # No message error should be triggered when the user already has a CPF registered
    Examples:
      | first | last    | date      | email       | cpf            | phone          | message |
      | luiz  | fonseca | 12111980  | test@test.com | 14606243430 | 21999998888     | Cpf já está em uso  |

