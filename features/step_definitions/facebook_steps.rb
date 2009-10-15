def mock_facebooker_session(attrs = {})
  attrs = {
    :auth_token => nil,
    :secret_key => "948accac0c5db5a8de4b030e1a4cd586",
    :expires => Time.now.tomorrow.to_i,
    :uid => 10712629,
    :api_key => "4d9693d7415fa14e4772bfaac0e4c7d7",
    :session_key => "3.JABlnBdkPDSH8BQNS7tyIw__.86400.1255669200-10712629",
    :secret_from_session => "frW9OcN8ImH4UOlxE_6Pgw__"
  }.merge(attrs)
  return mock("facebooker session", attrs)
end

def mock_facebooker_user(attrs = {})
  attrs = {
    :hometown_location => nil,
    :pic => nil,
    :uid => 10712629,
    :current_location => nil,
    :populated => false,
    :friends => nil,
    :id => nil
  }.merge(attrs)
  return mock("facebooker user", attrs)
end

Given /^facebook set up cookies for us$/ do
  cookies.merge!({
    "#{Facebooker.api_key}_session_key" => 'facebook_session_key',
    "#{Facebooker.api_key}_expires" => '0',
    "#{Facebooker.api_key}_user" => '1234',
    "#{Facebooker.api_key}_ss" => 'aoeu' }
  )
end

When "she signs in to facebook connect" do
  Given "facebook set up cookies for us"
  visit "/users/link_user_accounts"
end

### Handy object dumps from production

# <Facebooker::Session:0x1ff3b28 @auth_token=nil, @secret_key="948accac0c5db5a8de4b030e1a4cd586", @expires=1255669200, @uid=10712629, @api_key="4d9693d7415fa14e4772bfaac0e4c7d7", @session_key="3.JABlnBdkPDSH8BQNS7tyIw__.86400.1255669200-10712629", @secret_from_session="frW9OcN8ImH4UOlxE_6Pgw__">
# <Facebooker::User:0x1fea028 @hometown_location=nil, @pic=nil, @uid=10712629, @current_location=nil, @populated=false, @session=#<Facebooker::Session:0x1feae10 @user=#<Facebooker::User:0x1fea028 ...>, @auth_token=nil, @secret_key="948accac0c5db5a8de4b030e1a4cd586", @expires=1255669200, @uid=10712629, @api_key="4d9693d7415fa14e4772bfaac0e4c7d7", @session_key="3.JABlnBdkPDSH8BQNS7tyIw__.86400.1255669200-10712629", @secret_from_session="frW9OcN8ImH4UOlxE_6Pgw__">, @friends=nil, @id=nil>