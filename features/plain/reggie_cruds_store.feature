Feature: Registered user manipulates a Store
  
  As a registered user
  I want to manipulate a store
  So that I can group receipts by store
  
  Background:
    Given I am a registered user logged in as 'reggie'
      And There is an existing chain with name: "826 Seattle"
      
  Scenario: I see a new store form when I go to create a store
    When I go to make a new store
    Then I should see a <form> containing:
        | tag                         | label       |
        | textfield                   | Name        |
        | select[id="store_chain_id"] | 826 Seattle |
        | textfield                   | Street      |
        | textfield                   | City        |
        | textfield                   | State       |
        | textfield                   | Zip         |

  Scenario: I create a store
     When I go to make a new store
      And I select "826 Seattle" from "Chain"
      And I fill in:
        | field  | value                             |
        | Name   | Greenwood Space Travel Supply Co. |
        | Street | 8414 Greenwood Ave N              |
        | City   | Seattle                           |
        | State  | WA                                |
        | Zip    | 98103                             |
      And I press "Create"
     Then I should see "Store was successfully created"

  Scenario: I update a store
    Given There is an existing store with chain: "@chain"
     When I go to edit the store
      And I press "Update"
     Then I should see "Store was successfully updated"

