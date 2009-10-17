Given /^facebook set up cookies for us$/ do
  cookies.merge!({
    "#{Facebooker.api_key}_session_key" => 'facebook_session_key',
    "#{Facebooker.api_key}_expires"     => '0',
    "#{Facebooker.api_key}_user"        => '1234',
    "#{Facebooker.api_key}_ss"          => 'aoeu' 
  })
end

When "she signs in to facebook connect" do
  Given "facebook set up cookies for us"
  visit "/users/link_user_accounts"
end