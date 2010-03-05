Given /The list is set in my session/ do
  session[:list_id] = @list.id
end

Then /^I should see a link to add the recipe to my list$/ do
  response.should have_selector("a", :href => "/lists/add?recipe_id=#{@recipe.id}")
end