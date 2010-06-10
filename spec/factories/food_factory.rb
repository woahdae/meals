Factory.define :user_food do |food|
  food.name "burrito, chicken fajita"
  food.servings 2
  food.serving_size "170 g"
  food.kcal                  280
  food.fat_kcal              80 
  food.fat                   9  
  food.saturated_fat         2.5
  food.cholesterol           20 
  food.sodium                710
  food.carbs                 37 
  food.fiber                 3  
  food.sugar                 2  
  food.protein               14 
  food.vitamin_a_daily_value 4  
  food.vitamin_c_daily_value 0  
  food.calcium_daily_value   15 
  food.iron_daily_value      8  
end

Factory.define(:usda_ndb_food) do |food|
   food.name "Butter, salted"
   food.usda_ndb_id 1001
   food.servings nil
   food.serving_size nil
   food.common_weight 227.0
   food.common_weight_description "1 cup"
   food.calcium             24.0
   food.carbs               0.06
   food.cholesterol         215.0
   food.fat                 81.11
   food.fat_kcal            712.9569
   food.fiber               0.0
   food.iron                0.02
   food.kcal                717.0
   food.monounsaturated_fat 21.021
   food.polyunsaturated_fat 3.043
   food.protein             0.85
   food.saturated_fat       51.368
   food.sodium              576.0
   food.sugar               0.06
   food.vitamin_a           2499.0
   food.vitamin_c           0.0
end