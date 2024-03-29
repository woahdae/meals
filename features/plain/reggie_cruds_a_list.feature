Feature: Registered user manipulates a list
  
  As a registered user
  I want to manipulate a list
  So that I can see aggregate data or do something cool with it
  
  Background:
    Given I am a registered user logged in as 'reggie'
      And There are existing recipes with:
          | name      | servings | user  |
          | Spaghetti | 1        | @user |
      And There are existing usda_ndb_foods with:
          | name         | kcal |
          | Noodles, dry | 138  |
      And There are existing items with:
          | name    | qty  | recipe  | food           |
          | Noodles | 8 oz | @recipe | @usda_ndb_food |

  Scenario: I see links to add recipes to my list
       When I go to browse the recipes
       Then I should see a button to add the recipe to my list

  Scenario: I add a recipe to my list
       When I go to browse the recipes
        And I press "Add to list"
       Then I should see "Your List"

  Scenario: I add a food to my list
      Given There is an existing food with name: "burrito, chicken fajita"
       When I go to browse the food items
        And I press "Add"
       Then I should see "Your List"
  
  Scenario: I delete a recipe from my list
      Given I go to browse the recipes
        And I press "Add to list"
       Then I should see "Spaghetti • X"
       When I follow "X"
       Then I should not see "Spaghetti • X"

  Scenario: I clear my list
      Given I go to browse the recipes
        And I press "Add to list"
       Then I should see "Your List"
       When I follow "Clear"
       Then I should see "You have no items in your list"

  Scenario: I view my list to see aggregated nutrition data
      Given I go to browse the recipes
        And I press "Add to list"
        And I press "Add to list"
       When I follow "show_list"
       # 8 oz of noodles (NDB No 20510) = 313 kcal
       # There are 2 in our list
       Then I should see "Calories 626"

  Scenario: I view my list to see food items grouped together
      Given I go to browse the recipes
        And I press "Add to list"
        And I press "Add to list"
        And There is an existing food with name: "burrito, chicken fajita" and servings: "2" and serving_size: "170 grams"
        And I go to browse the food items
        And I follow "burrito, chicken fajita"
        And I press "Add"
       When I follow "show_list"
       Then I should see "Noodles 16 oz"
        And I should see "burrito, chicken fajita"
