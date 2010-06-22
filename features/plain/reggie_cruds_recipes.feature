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
      And I fill in "recipe[items_attributes][5][qty]" with "<amount>"
      And I press "Create"
     Then I should see a <message type> message '<message>'

    Examples: I successfully create a recipe
      | servings | amount | message type | message                         |
      | 1        | 8 oz   | notice       | Recipe was successfully created |
    
    Examples: I see validation falures when creating an invalid recipe
      | servings | amount | message type     | message                  |
      |          | 8 oz   | errorExplanation | Servings is not a number |

  Scenario: I edit a recipe and link items to a food
    Given There are existing recipes with:
          | name      | servings | user  |
          | Spaghetti | 1        | @user |
      And There is an existing usda_ndb_food with name: "Noodles, raw"
      And There are existing items with:
          | name    | qty  | recipe  |
          | Noodles | 8 oz | @recipe |
     When I go to edit the recipe
      And I select "Noodles, raw" from "recipe[items_attributes][0][food_id]"
      And I press "Update"
     Then I should see a notice message 'Recipe was successfully updated'

  Scenario: I can not edit someone else's recipe
    Given There is an existing recipe with user_id: 999
     When I go to edit the recipe
     Then I should see a error message 'You are not the owner of this recipe'

  Scenario: I view a recipe to ascertain cost information
    Given There is an existing recipe with name: "Green Eggs & Ham" and servings: "2"
      And There are existing usda_ndb_foods with:
        | name       |
        | Green Eggs |
        | Ham        |
      And There are existing items with:
        | name | qty  | food            | recipe  |
        | Eggs | 8 oz | @usda_ndb_food  | @recipe |
        | Ham  | 8 oz | @usda_ndb_food1 | @recipe |
      And There are existing receipt_items with:
        | name | qty   | price | food            |
        | Eggs | 1 lb  | 3.00  | @usda_ndb_food  |
        | Ham  | 2 lbs | 10.00 | @usda_ndb_food1 |
     When I go to view the recipe
     # 8 oz => 0.45 kg, 1 lb => 0.9 kg
     # eggs = ($3.00  / 0.9 kg) * 0.45 kg => $1.50
     # ham  = ($10.00 / 1.8 kg) * 0.45 kg => $2.50
     Then I should see "$ Total: $4.00"
      And I should see "$/Srv: $2.00"

  Scenario: I view a recipe to ascertain nutrition information
    Given There is an existing recipe with name: "Green Eggs & Ham" and servings: "2"
      And There are existing usda_ndb_foods with:
        | name        | kcal   |
        | Eggs, green | 107.1  |
        | Ham, fun    | 142.86 |
      And There are existing items with:
        | name | qty  | food            | recipe  |
        | Eggs | 8 oz | @usda_ndb_food  | @recipe |
        | Ham  | 8 oz | @usda_ndb_food1 | @recipe |
     When I go to view the recipe
     # 8 oz of eggs => 243 calories
     # 8 oz of ham  => 324 calories
     # / 2 servings
     Then I should see "Calories 283"

  Scenario: I view a recipe to ascertain nutrition information, but it is missing
    Given There is an existing recipe with name: "Green Eggs & Ham" and servings: "2"
      And There are existing usda_ndb_foods with:
        | name        | kcal   |
        | Eggs, green |        |
        | Ham, fun    | 142.86 |
      And There are existing items with:
        | name | qty  | food            | recipe  |
        | Eggs | 8 oz | @usda_ndb_food  | @recipe |
        | Ham  | 8 oz | @usda_ndb_food1 | @recipe |
     When I go to view the recipe
     Then I should see "Calories ?"

  Scenario: I view a recipe whose item contains a food with nil common_weight
    Given There is an existing recipe with name: "Green Eggs & Ham" and servings: "2"
      And There are existing usda_ndb_foods with:
        | name        | common_weight |
        | Eggs, green |               |
        | Ham, fun    | 142.86        |
      And There are existing items with:
        | name | qty  | food            | recipe  |
        | Eggs | 8 oz | @usda_ndb_food  | @recipe |
        | Ham  | 8 oz | @usda_ndb_food1 | @recipe |
     When I go to view the recipe
     Then I should see "Eggs 8 oz ?"
     
    
