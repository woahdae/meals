Given "I previously registered via facebook" do
  @user = User.new(:name => "Woody Peterson", :fb_id => "10712629").tap {|u| u.save(false)}
end

When "I log in via facebook" do
  visit "/session/from_facebook?code=NastyCode"
end
