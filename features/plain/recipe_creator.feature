Feature: Creating a password in checkout
  As a logged in user
  I want to create a recipe
  Including price and nutrition data
  In order to track my cost per meal, nutrition per meal, and save recipes for later

  Scenario: Start to create a recipe
    Given I am a registered user logged in as 'reggie'
    When I go to make a new recipe
    Then I should see a <form> containing a textfield: Name

  Scenario: Creating a recipe
    Given I am a registered user logged in as 'reggie'
    When I go to make a new recipe
    And I fill in "name" with "Spaghetti"
    And I fill in "servings" with "1"
    And I fill in "recipe[items_attributes][0][name]" with "Noodles"
    And I fill in "recipe[items_attributes][0][amount_with_unit]" with "8 oz"
    And I fill in "recipe[items_attributes][0][bulk_price]" with "4.00"
    And I fill in "recipe[items_attributes][0][bulk_qty_with_unit]" with "16 oz"
    And I press "Create"
    Then I should see a notice message 'Recipe was successfully created'

  Scenario: validation failure when creating a recipe
    Given I am a registered user logged in as 'reggie'
    When I go to make a new recipe
    And I fill in "name" with "Spaghetti"
    And I fill in "recipe[items_attributes][0][name]" with "Noodles"
    And I fill in "recipe[items_attributes][0][amount_with_unit]" with "8 oz"
    And I fill in "recipe[items_attributes][0][bulk_price]" with "4.00"
    And I fill in "recipe[items_attributes][0][bulk_qty_with_unit]" with "16 oz"
    And I press "Create"
    Then I should see an errorExplanation message 'Servings is not a number'
  