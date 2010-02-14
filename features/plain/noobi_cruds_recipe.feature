# Feature: New user manipulating recipes
# 
#   As an unregistered user
#   I want to manipulate recipes
#   So that I can experience the website without having to create an account
# 
# Scenario: Creating a recipe, hit the login screen, and after logging in it continues to process the recipe
#   Given an anonymous user
#     And There is an existing user with name: User, login: user, email: m@u.us, password: password, password_confirmation: password
#    When I go to make a new recipe
#     And I fill in "name" with "Spaghetti"
#     And I fill in "servings" with "1"
#     And I fill in "recipe[items_attributes][1][name]" with "Noodles"
#     And I fill in "recipe[items_attributes][1][amount_with_unit]" with "8 oz"
#     And I fill in "recipe[items_attributes][1][bulk_price]" with "4.00"
#     And I fill in "recipe[items_attributes][1][bulk_qty_with_unit]" with "16 oz"
#     And I press "Create"
#     And I fill in "Login" with "user"
#     And I fill in "Password" with "password"
#     And I press "Log in"
#    Then I should be on the page for the new recipe
#     And I should see a notice message 'Recipe was successfully created'
