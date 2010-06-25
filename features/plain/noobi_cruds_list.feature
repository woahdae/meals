Feature: Unregistered user manipulates a list
  
  As an unregistered user
  I want to manipulate a list
  So that I can see aggregate data or do something cool with it
  
  Background:
    Given I am an anonymous user
      And There are existing recipes with:
          | name      | servings | user_id |
          | Spaghetti | 1        | 1       |
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

  Scenario: I add an item_uid to my list
      Given There is an existing user_food with name: "burrito, chicken fajita"
       When I go to browse the food items
        And I press "Add to list"
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
       When I follow "clear"
       Then I should not see "Your List"

  Scenario: I view my list to see aggregated nutrition data
      Given I go to browse the recipes
        And I press "Add to list"
        And I press "Add to list"
       When I follow "show_list"
       # 8 oz of noodles = 313 kcal
       # There are 2 in our list
       Then I should see "Calories 626"

  Scenario: I view my list to see food items grouped together
      Given I go to browse the recipes
        And I press "Add to list"
        And I press "Add to list"
        And There is an existing user_food with name: "burrito, chicken fajita" and servings: "2" and serving_size: "170 grams"
        And I go to browse the food items
        And I follow "burrito, chicken fajita"
        And I press "Add to list"
       When I follow "show_list"
       Then I should see "Noodles 16 oz"
        And I should see "burrito, chicken fajita"

  Scenario: I remove list items from my list
      Given I go to browse the recipes
        And I press "Add to list"
        And I follow "show_list"
        And I click to delete the list item for the Noodles
       Then My list should no longer contain the Noodles

