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
    Given There is an existing user_food with:
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
     When I go to edit the user's food
      And I press "Update"
     Then I should see "Food was successfully updated"

  Scenario: I view a user defined food
    Given There is an existing user_food with:
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
    When I go to view the user's food
    Then I should see:
     | Calories 280      |
     | Total fat 9 g     |
     | Saturated fat 3 g |
     | Monounsat fat ?   |
     | Polyunsat fat ?   |
     | Total carbs 37 g  |
     | Dietary Fiber 3 g |
     | Sugars 2 g        |
     | Protein 14 g      |

  Scenario: I view a food from the nutrition database to ascertain nutrition info
    Given There is an existing usda_ndb_food with:
      | name                      | Butter, salted |
      | kcal                      | 717            |
      | fat                       | 81.11          |
      | fat_kcal                  | 712.96         |
      | saturated_fat             | 51.386         |
      | monounsaturated_fat       | 21.021         |
      | polyunsaturated_fat       | 3.043          |
      | cholesterol               | 215            |
      | sodium                    | 576            |
      | carbs                     | 0.06           |
      | fiber                     | 0              |
      | sugar                     | 0.06           |
      | protein                   | 0.85           |
      | vitamin_a                 | 2499           |
      | vitamin_c                 | 0              |
      | calcium                   | 24             |
      | iron                      | 0.02           |
      | common_weight             | 227            |
      | common_weight_description | 1 cup          |
    When I go to view the usda food
    Then I should see:
     | Calories 717       |
     | Total fat 81 g     |
     | Saturated fat 51 g |
     | Monounsat fat 21   |
     | Polyunsat fat 3    |
     | Total carbs 0 g    |
     | Dietary Fiber 0 g  |
     | Sugars 0 g         |
     | Protein 1 g        |

  Scenario: I view a food from the nutrition database to ascertain cost info
      Given There is an existing usda_ndb_food with:
          | name                      | Butter, salted |
          | common_weight             | 227            |
          | common_weight_description | 1 cup          |
        And There is an existing receipt_item with:
          | name  | butter         |
          | qty   | 2 cups         |
          | price | 5.00           |
          | food  | @usda_ndb_food |
       When I go to view the usda food
       Then I should see "Price: $2.50 USD/cu"
