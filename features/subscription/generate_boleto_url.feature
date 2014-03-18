Feature: Generate a boleto (slip) url so I can pay my donation
  In order to collaborate using the boleto payment option
  as an user
  I want to receive an URL containing my boleto 




  Scenario: A new user is subscribing
    Given I subscribed using boleto
    And I'm in the edit subscriber path
    Then I should see "O link para o seu boleto é <link>"
