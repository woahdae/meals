Feature: New user browses the site

  It is important to have new users see the site just as a registered user would,
  and be able to get a feel of what registering would offer. So, I want new users to see
  an example recipe in their "my recipes" page and have the ability to browse others' recipes

  Background
    Given I am an anonymous user

  Scenario: Anonymous user sees an example recipe and login/registration info
    Given  There is an example recipe
     When  I go to the homepage
     Then  I should see "Example Recipe"

  Scenario: Can look at another users recipes
    Given  There is an existing recipe with user_id: 1 and name: Meatloaf
     When  I go to /users/1-quentin/recipes
     Then  I should see "Meatloaf"
