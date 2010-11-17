class AddServingSizeToUsdaNdbFoods < ActiveRecord::Migration
  def self.up
    UsdaNdbFood.update_all("serving_size = '100 grams'")
    UsdaNdbFood.update_all("servings = 1")
  end

  def self.down
    UsdaNdbFood.update_all("serving_size = NULL")
    UsdaNdbFood.update_all("servings = NULL")
  end
end
