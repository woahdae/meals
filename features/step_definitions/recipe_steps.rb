Given "There is an existing $factory with $attributes" do |factory, attributes|
  attributes = attributes.to_hash_from_story
  
  ivar = instance_variable_set("@#{factory}", Factory.create(factory.to_sym, attributes))
end

Given "There is an example recipe" do
  anan_recipe = Factory.build(:recipe, :name => "Example Recipe", :user_id => nil)
  anan_recipe.save(false)
end