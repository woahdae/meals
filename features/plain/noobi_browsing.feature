Feature: New user browses the site

  It is important to have new users see the site just as a registered user would,
  and be able to get a feel of what registering would offer. So, I want new users to see
  an example recipe in their "my recipes" page and have the ability to browse others' recipes

  Background
    Given I am an anonymous user
  
  Scenario: I see all recipes from the home page
    Given  There is an existing recipe_with_item with name: "Spit on a Stick" and user_id: 1
     When  I go to the homepage
     Then  I should see "Spit on a Stick"

  Scenario: I can look at another users recipes
    Given  There is an existing recipe_with_item with user_id: 1 and name: Meatloaf
     When  I go to /users/1-quentin/recipes
     Then  I should see "Meatloaf"

  Scenario: I can see my own recipes after I log in
    Given  There is an existing recipe_with_item with user_id: 1 and name: Meatloaf
      And  I go to the homepage
      And  I fill in "Username:" with "quentin"
      And  I fill in "Password:" with "monkey"
      And  I press "Login"
     When  I follow "Recipes" within "#login_bar"
     Then  I should see "Your Recipes"
      And  I should see "Meatloaf"
