Feature: Registered user manipulates a Chain
  
  As a registered user
  I want to manipulate a chain
  So that I can group stores by chain
  
  Background:
    Given I am a registered user logged in as 'reggie'
    
  Scenario: I see a new chain form when I go to create a chain
    When I go to make a new chain
    Then I should see a <form> containing:
      | tag                         | label  |
      | textfield                   | Name   |

  Scenario: I create a chain
     When I go to make a new chain
      And I fill in "Name" with "826 Seattle"
      And I press "Create"
     Then I should see "Chain was successfully created"

  Scenario: I update a chain
    Given There is an existing chain with name: "826 Seattle"
     When I go to edit the chain
      And I press "Update"
     Then I should see "Chain was successfully updated"

