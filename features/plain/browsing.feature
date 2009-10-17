I think it is important to have new users see the site just as a registered user would,
and be able to get a feel of what registering would offer. So, I want new users to see
an example recipe in their "my recipes" page (in addition to registration info)

  Scenario: Anonymous user sees an example recipe and login/registration info
   Given  an anonymous user
     And  There is an example recipe
    When  I go to the homepage
    Then  I should see "Example Recipe"

  Scenario: Can look at another users recipes
    Given  an anonymous user
      And  There is an existing recipe with user_id: 1, name: Meatloaf
     When  I go to /users/1-quentin/recipes
     Then  I should see "Meatloaf"
