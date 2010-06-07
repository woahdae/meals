unless ItemUID.first(:conditions => "usda_ndb_id IS NOT NULL")
  UsdaNdb::AbbreviatedData.find_each {|usda_data| ItemUID.create(:usda_ndb_id => usda_data.ndb_no)}
end

UsdaNdb::AbbreviatedData.find_each do |datum|
  description = UsdaNdb::FoodDescription.find(datum.id)
  Food.create(
    "name"                => description.long_description,
    "usda_ndb_id"         => datum.id,
    "kcal"                => datum.kcal,
    "fat"                 => datum.fat,
    "saturated_fat"       => datum.saturated_fat,
    "monounsaturated_fat" => datum.monounsaturated_fat,
    "polyunsaturated_fat" => datum.polyunsaturated_fat,
    "cholesterol"         => datum.cholesterol,
    "carbs"               => datum.carbs,
    "protein"             => datum.protein,
    "sugar"               => datum.sugar,
    "fiber"               => datum.fiber,
    "fat_kcal"            => datum.fat * description.fat_factor,
    "sodium"              => datum.sodium,
    "vitamin_a"           => datum.vitamin_a_iu,
    "vitamin_c"           => datum.vitamin_c,
    "calcium"             => datum.calcium,
    "iron"                => datum.iron,
    "grams"               => datum.weight_1,
    "volume"              => datum.weight_1_description
  )
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
      "name"=>"Green Eggs and Ham",
      "directions"=>
       "* Seperate the yolk from the whites\r\n* Add Food coloring to the egg whites. The color you see in the uncooked yolk will be much darker than the color after they are done.\r\n* Gently add yolk back. Don't break it.\r\n\r\nNow for the ham, I like to have a souther flavor to my pork. I made a special concoction that is vinegar based BBQ sauce. Use whatever you like, water is a good non flavor.\r\n\r\n* Find the ham you need. Drier is better cause it helps absorb more.\r\n* Get a clear sauce (water works too) mix in the color you want\r\n* Brush on, or soak your ham with the new colored mix. Remember: You are going to be painting on a pink canvas so take that into consideration.\r\n* Cook up your food like you normally would. ",
      "user"=>user,
      "servings"=>1,
      "cook_time"=>10.0,
      "items" => [
        Item.new(
          "name"=>"Green Eggs",
          "qty"=>"10 oz"),
        Item.new(
          "name"=>"Ham",
          "qty"=>"8 oz") ])
    recipe.photos << RecipePhoto.create(:uploaded_data => LocalFile.new("#{Rails.root}/public/green_eggs_and_ham.gif"))
    recipe.save
  end
  
  unless Food.count > 0
    Food.create(
      :name => "burrito, chicken fajita, trader joes",
      :kcal => 280,
      :fat_kcal => 80,
      :fat => 9,
      :saturated_fat => 2.5,
      :cholesterol => 20,
      :sodium => 710,
      :carbs => 37,
      :fiber => 3,
      :sugar => 2,
      :protein => 14,
      :dv_vitamin_a => 4,
      :dv_vitamin_c => 0,
      :dv_calcium   => 15,
      :dv_iron      => 8 )
  end
end










