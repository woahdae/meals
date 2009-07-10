Feature: Creating a password in checkout
  As a logged in user
  I want to create a recipe
  Including price and nutrition data
  In order to track my cost per meal, nutrition per meal, and save recipes for later

  Scenario: Start to create a recipe
    Given I am a registered user logged in as 'reggie'
    When I go to "/recipies/new"
    Then I should see a <form> containing a textfield: Name

  Scenario: Creating a recipe
    Given I am a registered user logged in as 'reggie'
    When I go to "/recipies/new"
    And I fill in "name" with "Spaghetti"
    And I press "submit"
    Then I should see a notice message 'New Recipe Created'
    And I should be redirected to the page for the new recipe