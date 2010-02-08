unless ItemUID.first(:conditions => "usda_ndb_id IS NOT NULL")
  UsdaNdb::AbbreviatedData.find_each {|usda_data| ItemUID.create(:usda_data => usda_data)}
end

# recipes without a user are put on the front page when not logged in
unless Recipe.first(:conditions => "user_id IS NULL").present?
  require 'lib/local_file'
  recipe = Recipe.new(
    "prep_time"=>10.0,
    "name"=>"Green Eggs and Ham",
    "directions"=>
     "* Seperate the yolk from the whites\r\n* Add Food coloring to the egg whites. The color you see in the uncooked yolk will be much darker than the color after they are done.\r\n* Gently add yolk back. Don't break it.\r\n\r\nNow for the ham, I like to have a souther flavor to my pork. I made a special concoction that is vinegar based BBQ sauce. Use whatever you like, water is a good non flavor.\r\n\r\n* Find the ham you need. Drier is better cause it helps absorb more.\r\n* Get a clear sauce (water works too) mix in the color you want\r\n* Brush on, or soak your ham with the new colored mix. Remember: You are going to be painting on a pink canvas so take that into consideration.\r\n* Cook up your food like you normally would. ",
    "user_id"=>nil,
    "servings"=>1,
    "cook_time"=>10.0,
    "items" => [
      Item.new(
        "name"=>"Green Eggs",
        "bulk_qty"=>0.907185,
        "bulk_price" => 5.00,
        "amount_unit"=>"oz",
        "bulk_qty_unit"=>"oz",
        "amount"=>0.283495),
      Item.new(
        "name"=>"Ham",
        "bulk_qty"=>0.453592,
        "amount_unit"=>"oz",
        "bulk_qty_unit"=>"lb",
        "amount"=>0.226796,
        "bulk_price"=> 5.00) ])
  recipe.photos << RecipePhoto.create(:uploaded_data => LocalFile.new("#{Rails.root}/public/green_eggs_and_ham.gif"))
  recipe.save(false) # usually can't make a recipe w/o a user
end

if Rails.env == 'development'
  user = User.find_by_login("admin") || User.create(
    :login => "admin",
    :email => "woody.peterson@gmail.com",
    :password => "password",
    :password_confirmation => "password")
  
  unless user.recipes.any?
    require 'lib/local_file'
    recipe = Recipe.new(
      "prep_time"=>10.0,
      "name"=>"Admin's Green Eggs and Ham",
      "directions"=>
       "* Seperate the yolk from the whites\r\n* Add Food coloring to the egg whites. The color you see in the uncooked yolk will be much darker than the color after they are done.\r\n* Gently add yolk back. Don't break it.\r\n\r\nNow for the ham, I like to have a souther flavor to my pork. I made a special concoction that is vinegar based BBQ sauce. Use whatever you like, water is a good non flavor.\r\n\r\n* Find the ham you need. Drier is better cause it helps absorb more.\r\n* Get a clear sauce (water works too) mix in the color you want\r\n* Brush on, or soak your ham with the new colored mix. Remember: You are going to be painting on a pink canvas so take that into consideration.\r\n* Cook up your food like you normally would. ",
      "user"=>user,
      "servings"=>1,
      "cook_time"=>10.0,
      "items" => [
        Item.new(
          "name"=>"Green Eggs",
          "bulk_qty"=>0.907185,
          "bulk_price" => 5.00,
          "amount_unit"=>"oz",
          "bulk_qty_unit"=>"oz",
          "amount"=>0.283495),
        Item.new(
          "name"=>"Ham",
          "bulk_qty"=>0.453592,
          "amount_unit"=>"oz",
          "bulk_qty_unit"=>"lb",
          "amount"=>0.226796,
          "bulk_price"=> 5.00) ])
    recipe.photos << RecipePhoto.create(:uploaded_data => LocalFile.new("#{Rails.root}/public/green_eggs_and_ham.gif"))
    recipe.save
  end
end