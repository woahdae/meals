Feature: facebook connect
  In order to get more users
  As a site owner
  I want users to easily sign in and sign up via facebook
  
  Scenario: sign in via facebook when being connected
    Given a user who is connected via facebook
    When I go to the homepage
    And I sign in via facebook
    Then I should see "Welcome"
    
  Scenario: sign in via facebook when not being connected
    Given an anonymous user with login: "booyeah" and email: "your@mom.com"
    When I go to the homepage
    And I sign in via facebook
    Then I should see "Welcome"
  
  # Scenario: sign up via facebook
    # When I go to the homepage
    # And I sign up via facebook
    # Then I should not see "Password"
    # When I fill in "Email" with "email@person.com"
    # And I press "Sign Up"
    # Then I should see "instructions for confirming"
    # And a confirmation message should be sent to "email@person.com"
    # And my facebook id should be set
