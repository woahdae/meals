Feature: Creating an account
  As an anonymous user
  I want to be able to create an account or log in via facebook
  So that I can be one of the cool kids, but without the work

  Scenario: I create an account via facebook
      Given an anonymous user
       When I log in via facebook
       Then I should see a notice message 'Logged in via Facebook'

  Scenario: I log in to an existing account via facebook
      Given I previously registered via facebook
        And I am on the homepage
       When I log in via facebook
       Then I should see a notice message 'Logged in via Facebook'

  # if I register a user through entering my details and later login through 
  # Facebook Connect I want to make sure I retain my old user account
  Scenario: I retain old user account when logging in via facebook
    Given a registered user logged in as 'reggie'
    When  I log in via facebook
    Then  I should see a notice message 'Connected your account to facebook'
    