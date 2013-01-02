Feature: Support the project
  In order to support the cause
  as a backer
  I want to support the project


  Scenario: I want to donate 10 bucks
    Given there is a project "Apoie meu projeto" with 25000 of goal and expires in 45 days
    And I'm in the home page
    When I click "Apoie agora!"
    Then I should see "Escolha como pretende apoiar!"
    And I should see "Nome"
    And I should see "CPF"
    And I should see "Data de Nascimento"
    And I should see "Endereço"
    And I should see "E-mail"
    And I should see "Celular"

