Feature: Support the project
  In order to support the cause
  as a backer
  I want to support the project


  @javascript
  Scenario: I choose boleto to back this project
    Given there is a project "Apoie meu projeto" with 25000 of goal and expires in 45 days
    And I'm in the home page
    And I click "Apoie agora!"
    Then I should see "Apoie com um valor e você ganha um brinde especial logo após :)"
    Then I click "R$ 10"
    Then I should see "Escolha como pretende apoiar o projeto!"
    Then I should see "Boleto"
    Then I should see "Cartão de Crédito"
    When I click "Boleto"
    And I fill in "Nome completo" with "Luiz Fonseca"
    And I fill in "Data de Nascimento" with "12/11/1988"
    And I fill in "Seu CPF" with "011.111.111-70"
    And I fill in "Endereço" with "Rua X Casa 08"
    And I fill in "Complemento" with "Nenhum"
    And I fill in "CEP" with "22245-050"
    And I fill in "Estado" with "RJ"
    And I fill in "Número" with "544"
    And I fill in "Cidade" with "Rio de Janeiro"
    And I fill in "Bairro" with "Laranjeiras"
    And I fill in "Seu email" with "email@email.com.br"
    And I fill in "Celular (ou fixo, insira o DDD)" with "(21) 97137471"
    And I click "Apoiar"
    Then I should see "Aguarde..." 
    And I should see "O link para pagamento do seu boleto (clique para abrir em uma outra janela)"


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
    And I click "Apoiar"
    Then I should not see "Não pode ficar em branco"

