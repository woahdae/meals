@iphone
Feature: Mobile user browsing the site

  As a user on a mobile device
  I want to look up recipes and add them to my list  
  So that I can shop on-the-go

  Background:
    Given There are existing recipes with:
        | name      | servings | user_id |
        | Spaghetti | 1        | 1       |
      And There are existing items with:
        | name    | qty  | recipe  |
        | Noodles | 8 oz | @recipe |
    
  Scenario: I see all recipes from the home page
       When I go to the homepage
       Then I should see "Spaghetti"

  Scenario: I view a recipe
       When I go to the homepage
        And I follow "Spaghetti"
       Then I should see "Spaghetti"

  Scenario: I add a recipe to my list
       When I go to the homepage
        And I press "Add to list"
        # the javascript comes back as text in webrat,
        # so we gotta re-visit the home page
        And I go to the homepage
        And I follow "List"
       Then I should see "Spaghetti"

  Scenario: I clear my list
      Given I go to the homepage
        And I press "Add to list"
        And I go to the homepage
        And I follow "List"
       When I follow "clear"
        And I go to the homepage
        And I follow "List"
       Then I should not see "Spaghetti"

  Scenario: I remove one item from my list
       When I go to the homepage
        And I press "Add to list"
        And I go to the homepage
        And I follow "List"
        And I click to delete the list item for the Noodles
       Then My list should no longer contain the Noodles
