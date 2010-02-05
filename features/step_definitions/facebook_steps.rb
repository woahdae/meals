Given /^facebook set up cookies for us$/ do
  cookies.merge!({
    "#{12345}_session_key" => 'facebook_session_key',
    "#{12345}_expires"     => '0',
    "#{12345}_user"        => '1234',
    "#{12345}_ss"          => 'aoeu' 
  })
end

When "she signs in to facebook connect" do
  Given "facebook set up cookies for us"
  visit "/users/link_user_accounts"
end