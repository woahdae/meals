Given /There is an existing recipe( with (.*))?/ do |with, attributes|
  attributes = attributes.try(:to_hash_from_story) || {}

  ivar = instance_variable_set("@recipe", Factory.create(:recipe, attributes))
  ivar.update_attribute(:user_id, @user.id) if @user && attributes[:user_id].nil?
end

Given /There is an existing item for the recipe( with (.*))?/ do |with, attributes|
  attributes = attributes.try(:to_hash_from_story) || {}
  
  ivar = instance_variable_set("@item", Factory.create(:item, attributes))
  @recipe.items << ivar
end

Given "There is an example recipe" do
  anan_recipe = Factory.build(:recipe, :name => "Example Recipe", :user_id => nil)
  anan_recipe.save(false)
end