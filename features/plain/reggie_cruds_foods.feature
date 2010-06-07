Feature: Registered user manipulates food data
  
  As a registered user
  I want to manipulate a food entry
  So that I can track my custom food items
  
  Background:
    Given I am a registered user logged in as 'reggie'
    
  Scenario: I see a new food form when I go to create a food
    When I go to make a new food
    Then I should see a <form> containing:
      | tag       | label |
      | textfield | Name  |

  Scenario: I create a food
     When I go to make a new food
      And I fill in:
      | field         | value                                |
      | name          | burrito, chicken fajita, trader joes |
      | servings      | 2                                    |
      | serving size  | 170 grams                            |
      | kcal          | 280                                  |
      | fat kcal      | 80                                   |
      | fat           | 9                                    |
      | saturated fat | 2.5                                  |
      | cholesterol   | 20                                   |
      | sodium        | 710                                  |
      | carbs         | 37                                   |
      | fiber         | 3                                    |
      | sugar         | 2                                    |
      | protein       | 14                                   |
      | Vitamin A     | 4                                    |
      | Vitamin C     | 0                                    |
      | Calcium       | 15                                   |
      | Iron          | 8                                    |
      And I press "Create"
     Then I should see "Food was successfully created"

  Scenario: I update a food
    Given There is an existing food with:
      | name          | burrito, chicken fajita, trader joes |
      | servings      | 2                                    |
      | serving_size  | 170 grams                            |
      | kcal          | 280                                  |
      | fat_kcal      | 80                                   |
      | fat           | 9                                    |
      | saturated_fat | 2.5                                  |
      | cholesterol   | 20                                   |
      | sodium        | 710                                  |
      | carbs         | 37                                   |
      | fiber         | 3                                    |
      | sugar         | 2                                    |
      | protein       | 14                                   |
      | vitamin_a     | 200                                  |
      | vitamin_c     | 0                                    |
      | calcium       | 150                                  |
      | iron          | 1.44                                 |
     When I go to edit the food
      And I press "Update"
     Then I should see "Food was successfully updated"

  Scenario: I view a food
    Given There is an existing food with:
      | name          | burrito, chicken fajita, trader joes |
      | servings      | 2                                    |
      | serving_size  | 170 grams                            |
      | kcal          | 280                                  |
      | fat_kcal      | 80                                   |
      | fat           | 9                                    |
      | saturated_fat | 2.5                                  |
      | cholesterol   | 20                                   |
      | sodium        | 710                                  |
      | carbs         | 37                                   |
      | fiber         | 3                                    |
      | sugar         | 2                                    |
      | protein       | 14                                   |
      | vitamin_a     | 200                                  |
      | vitamin_c     | 0                                    |
      | calcium       | 150                                  |
      | iron          | 1.44                                 |
    When I go to view the food
    Then I should see:
     | Calories 280      |
     | Total fat 9 g     |
     | Saturated fat 3 g |
     | Total carbs 37 g  |
     | Dietary Fiber 3 g |
     | Sugars 2 g        |
     | Protein 14 g      |
     And I should not see:
     | Monounsat fat |
     | Polyunsat fat |
    
    
    
    
    
    
    
    
    
    
    
    
