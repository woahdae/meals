Feature: Registered user manipulates food data
  
  As a registered user
  I want to manipulate a food entry
  So that I can track my custom food items
  
  Background:
    Given I am a registered user logged in as 'reggie'
    
  Scenario: I see a new food form when I go to create a food
    When I go to make a new food
    Then I should see a <form> containing:
      | tag                         | label  |
      | textfield                   | Name   |

  Scenario: I create a food
     When I go to make a new food
      And I fill in "Name" with "Green Goo"
      And I press "Create"
     Then I should see "Food was successfully created"

  Scenario: I update a food
    Given There is an existing food with name: "Green Goo"
     When I go to edit the food
      And I press "Update"
     Then I should see "Food was successfully updated"

