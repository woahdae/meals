Feature: Logging in
  As an anonymous user with an account
  I want to log in to my account
  So that I can be myself

  #
  # Log in: get form
  #
  Scenario: Anonymous user can get a login form.
    Given an anonymous user
    When  she goes to /login
    Then  she should be at the new sessions page
     And  the page should look AWESOME
     And  she should see a <form> containing a textfield: Login and password: Password and submit: 'Log in'
  
  #
  # Log in successfully, but don't remember me
  #
  Scenario: Anonymous user can log in
    Given an anonymous user
     And  an activated user named 'reggie'
    When  she creates a singular sessions with login: 'reggie' and password: 'monkey' and remember me: ''
    Then  she should be redirected to the home page
    When  she follows that redirect!
    Then  she should see a notice message 'Logged in successfully'
     And  reggie should be logged in
     And  she should not have an auth_token cookie
   
  Scenario: Logged-in user who logs in should be the new one
    Given an activated user named 'reggie'
     And  an activated user logged in as 'oona'
    When  she creates a singular sessions with login: 'reggie' and password: 'monkey' and remember me: ''
    Then  she should be redirected to the home page
    When  she follows that redirect!
    Then  she should see a notice message 'Logged in successfully'
     And  reggie should be logged in
     And  she should not have an auth_token cookie
  
  #
  # Log in successfully, remember me
  #
  Scenario: Anonymous user can log in and be remembered
    Given an anonymous user
     And  an activated user named 'reggie'
    When  she creates a singular sessions with login: 'reggie' and password: 'monkey' and remember me: '1'
    Then  she should be redirected to the home page
    When  she follows that redirect!
    Then  she should see a notice message 'Logged in successfully'
     And  reggie should be logged in
     And  she should have an auth_token cookie
     And  her session store user_id should equal her user id
   
  #
  # Log in unsuccessfully
  #
  
  Scenario: Logged-in user who fails logs in should be logged out
    Given an activated user named 'oona'
    When  she creates a singular sessions with login: 'oona' and password: '1234oona' and remember me: '1'
    Then  she should be redirected to the home page
    When  she follows that redirect!
    Then  she should see a notice message 'Logged in successfully'
     And  oona should be logged in
     And  she should have an auth_token cookie
    When  she creates a singular sessions with login: 'reggie' and password: 'i_haxxor_joo'
    Then  she should be at the new sessions page
    Then  she should see an error message 'Couldn't log you in as 'reggie''
     And  she should not be logged in
     And  she should not have an auth_token cookie
     And  her session store should not have user_id
  
  Scenario: Log-in with bogus info should fail until it doesn't
    Given an activated user named 'reggie'
    When  she creates a singular sessions with login: 'reggie' and password: 'i_haxxor_joo'
    Then  she should be at the new sessions page
    Then  she should see an error message 'Couldn't log you in as 'reggie''
     And  she should not be logged in
     And  she should not have an auth_token cookie
     And  her session store should not have user_id
    When  she creates a singular sessions with login: 'reggie' and password: ''
    Then  she should be at the new sessions page
    Then  she should see an error message 'Couldn't log you in as 'reggie''
     And  she should not be logged in
     And  she should not have an auth_token cookie
     And  her session store should not have user_id
    When  she creates a singular sessions with login: '' and password: 'monkey'
    Then  she should be at the new sessions page
    Then  she should see an error message 'Couldn't log you in as '''
     And  she should not be logged in
     And  she should not have an auth_token cookie
     And  her session store should not have user_id
    When  she creates a singular sessions with login: 'leonard_shelby' and password: 'monkey'
    Then  she should be at the new sessions page
    Then  she should see an error message 'Couldn't log you in as 'leonard_shelby''
     And  she should not be logged in
     And  she should not have an auth_token cookie
     And  her session store should not have user_id
    When  she creates a singular sessions with login: 'reggie' and password: 'monkey' and remember me: '1'
    Then  she should be redirected to the home page
    When  she follows that redirect!
    Then  she should see a notice message 'Logged in successfully'
     And  reggie should be logged in
     And  she should have an auth_token cookie
     And  her session store user_id should equal her user id


  #
  # Log out successfully (should always succeed)
  #
  Scenario: Anonymous (logged out) user can log out.
    Given an anonymous user
    When  she goes to /logout
    Then  she should be redirected to the home page
    When  she follows that redirect!
    Then  she should see a notice message 'You have been logged out'
     And  she should not be logged in
     And  she should not have an auth_token cookie
     And  her session store should not have user_id

  Scenario: Logged in user can log out.
    Given an activated user logged in as 'reggie'
    When  she goes to /logout
    Then  she should be redirected to the home page
    When  she follows that redirect!
    Then  she should see a notice message 'You have been logged out'
     And  she should not be logged in
     And  she should not have an auth_token cookie
     And  her session store should not have user_id
