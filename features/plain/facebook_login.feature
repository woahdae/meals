Visitors would probably find it easier to just use their facebook account than
create their own account, or if they just dont feel like remembering two passwords.

Story: Creating an account
  As an anonymous user
  I want to be able to create an account via facebook
  So that I can be one of the cool kids, but without the work

  #
  # Account Creation
  #
  Scenario: Anonymous user can create an account on our site via facebook
    Given an anonymous user
    When  she signs in to facebook connect
    Then  she should see a notice message 'Thanks for signing up!'
     And  a user with login: 'facebook_1234' should exist
     And  the user should have login: 'facebook_1234', and name: 'Dave Fetterman'
     And  facebook_1234 should be logged in

  # As a user if I register a user through entering my details and later login through 
  # Facebook Connect I want to make sure I retain my old user account
  Scenario: Registered users retain old user account when logging in for the first time through Facebook Connect
    Given a registered user logged in as 'reggie'
    When  she signs in to facebook connect
    Then  she should see a notice message 'Logged in via Facebook'
     And  she should have fb_id: 1234
    