Feature: Registered user manipulates recipes

  As a logged in user
  I want to manipulate a recipe
  In order to save it for later and use it in the aggregation features

  Background:
    Given I am a registered user logged in as 'reggie'

  Scenario: I see a new recipe form when I go to make a new recipe
     When I go to make a new recipe
     Then I should see a <form> containing a textfield: Name
  
  Scenario Outline: creating a recipe
     When I go to make a new recipe
      And I fill in "name" with "Spaghetti"
      And I fill in "servings" with "<servings>"
      And I fill in "recipe[items_attributes][5][name]" with "Noodles"
      And I fill in "recipe[items_attributes][5][amount_with_unit]" with "<amount>"
      And I press "Create"
     Then I should see a <message type> message '<message>'

    Examples: I successfully create a recipe
      | servings | amount | message type | message                         |
      | 1        | 8 oz   | notice       | Recipe was successfully created |
    
    Examples: I see validation falures when creating an invalid recipe
      | servings | amount | message type     | message                  |
      |          | 8 oz   | errorExplanation | Servings is not a number |

  Scenario: I edit a recipe and link items to an ItemUID
    Given There are existing recipes with:
          | name      | servings | user  |
          | Spaghetti | 1        | @user |
      And There is an existing item_uid with usda_ndb_id: "20133"
      And There are existing items with:
          | name      | amount_with_unit | recipe  |
          | Noodles   | 8 oz             | @recipe |
     When I go to edit the recipe
      And I select "RICE NOODLES,DRY" from "recipe[items_attributes][0][item_uid_id]"
      And I press "Update"
     Then I should see a notice message 'Recipe was successfully updated'
  
  Scenario: I can not edit someone else's recipe
    Given There is an existing recipe with user_id: 999
     When I go to edit the recipe
     Then I should see a error message 'You are not the owner of this recipe'

  Scenario: I view a recipe to ascertain cost information
    Given There is an existing recipe with name: "Green Eggs & Ham" and servings: "2"
      And There are existing items with:
        | name | amount_with_unit | item_uid_id | recipe  |
        | Eggs | 8 oz             | 38446       | @recipe |
        | Ham  | 8 oz             | 39937       | @recipe |
      And There are existing receipt_items with:
        | name | qty_with_unit    | price | item_uid_id |
        | Eggs | 1 lb             | 3.00  | 38446       |
        | Ham  | 2 lbs            | 10.00 | 39937       |
     When I go to view the recipe
     # 8 oz => 0.45 kg, 1 lb => 0.9 kg
     # eggs = ($3.00  / 0.9 kg) * 0.45 kg => $1.50
     # ham  = ($10.00 / 1.8 kg) * 0.45 kg => $2.50
     Then I should see "Total Price: $4.00"
      And I should see "Price Per Serving: $2.00"
      
    
    
    
    
    