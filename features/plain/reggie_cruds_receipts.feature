Feature: Registered user manipulating receipts

  As a logged in user
  I want to manipulate a receipt
  Including items on the receipt
  So that I can track the cost of items

  Background:
    Given I am a registered user logged in as 'reggie'
  
  Scenario: I see a new receipt form when I go to make a new receipt
     When I go to make a new receipt
     Then I should see a <form> containing:
          | tag                                          | label |
          | select[id="receipt_store_id"]                |       |
          | input[id="receipt_items_attributes_0_name"]  |       |
          | input[id="receipt_items_attributes_19_name"] |       |
  
  Scenario Outline: creating receipts
    Given There is an existing store with name: "Space Travel Supply Co."
     When I go to make a new receipt
      And I select "Space Travel Supply Co." from "Store"
      And I fill in "receipt_items_attributes_0_name" with "Space Goo"
      And I fill in "receipt_items_attributes_0_qty" with "<unit>"
      And I fill in "receipt_items_attributes_0_price" with "1000000.00"
      And I press "Create"
     Then I should see "<message>"
  
    Examples: I successfully create a receipt
      | unit  | message                          |
      | 5 lbs | Receipt was successfully created |
  
    Examples: I see a validation failure when creating an invalid receipt item
      | unit      | message                       |
      | 5 garbles | '5 garbles' is not a valid unit |
  
  Scenario: I edit a receipt and link it to an ItemUID
      And There is an existing store with name: "Space Travel Supply Co."
      And There is an existing receipt with user: "@user" and store: "@store"
      And There is an existing receipt_item with name: "Noodles" and receipt: "@receipt"
      And There is an existing food with name: "Noodles, dry"
     When I go to edit the receipt
      And I select "Noodles, dry" from "receipt[items_attributes][0][food_id]"
      And I press "Update"
     Then I should see "Receipt was successfully updated"
  
  Scenario: I can not edit someone else's receipt
      And There is an existing receipt with user_id: 999
     When I go to edit the receipt
     Then I should see a error message 'You are not the owner of this receipt'
  
  Scenario: I view a receipt
    Given There is an existing store with name: "Trader Joes"
    Given There is an existing receipt with user: "@user" and store: "@store"
      And There are existing receipt_items with:
          | name    | qty   | price | receipt  |
          | Noodles | 12 oz | 1.50  | @receipt |
          | Sauce   | 1 lb  | 3.00  | @receipt |
     When I go to view the receipt
     Then I should see "Noodles"
      And I should see "1 lb"
      And I should see "$3.00"
  
  
  
  
  
  
  
