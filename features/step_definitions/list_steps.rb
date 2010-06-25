Given /The list is set in my session/ do
  session[:list_id] = @list.id
end

Given %(I search for "$term") do |term|
  Given %(I fill in "Search" with "#{term}")
  Given %(I press "Submit")
end

Then /^I should see a button to add the recipe to my list$/ do
  response.should have_selector("form", :action => "/lists/add?recipe_id=#{@recipe.id}")
end

When "I click to delete the list item for the Noodles" do
  @list = List.last
  When %(I press "delete_list_items_#{@list.list_items.to_a.find {|li| li.name =~ /Noodles/}.id}")
end

Then "My list should no longer contain the Noodles" do
  @list.list_items.reload.to_a.find {|li| li.name == "Noodles"}\
    .should be_nil
end