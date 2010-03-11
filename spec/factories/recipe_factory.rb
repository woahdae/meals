Factory.define :recipe do |recipe|
  recipe.name "Example Recipe"
  recipe.prep_time 1.5
  recipe.cook_time 1.5
  recipe.servings 1
  recipe.directions "value for directions"
  recipe.user_id 1
end

Factory.define :recipe_with_item, :parent => :recipe do |recipe|
  recipe.items {|a| [a.association(:item)]}
end