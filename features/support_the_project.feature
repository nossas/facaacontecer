Feature: Support the project
  In order to support the cause
  as a backer
  I want to support the project


  @javascript
  Scenario: I choose one option to back this project
    Given there is a project "Apoie meu projeto" with 25000 of goal and expires in 45 days
    And I'm in the home page
    And I click "Apoie agora!"
    Then I should see "O que você gostaria de receber como recompensa pelo apoio?"
    When I click "R$ 10"
    Then I should see "Escolha como pretende apoiar o projeto!"
    Then I should see "Boleto"
    Then I should see "Cartão de crédito"


  Scenario: I fill all required fields
    Given there is a project "Apoie meu projeto" with 25000 of goal and expires in 45 days
    And I'm in the home page
    When I click "Apoie agora!"
    When I fill in "Nome completo" with "Luiz"
    When I fill in "CPF" with "011.111.111-70"
    When I fill in "Endereço" with "Rua X Casa 08"
    When I fill in "Complemento" with "Nenhum"
    When I fill in "CEP" with "22245-050"
    When I fill in "Estado" with "RJ"
    When I fill in "Número" with "544"
    When I fill in "Cidade" with "Rio de Janeiro"
    When I fill in "Bairro" with "Laranjeiras"
    When I fill in "Seu email" with "email@email.com.br"
    When I fill in "Celular" with "(21) 9713-7471"
    And I click "Salvar Order"
    Then I should not see "Não pode ficar em branco"

