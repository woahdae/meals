Given "There is an example recipe" do
  anan_recipe = Factory.build(:recipe, :name => "Example Recipe", :user_id => nil)
  anan_recipe.save(false)
end