class MoveFoodsDailyValueNutritionToJustValue < ActiveRecord::Migration
  def self.up
    add_column :foods, :vitamin_a, :float
    add_column :foods, :vitamin_c, :float
    add_column :foods, :calcium, :float
    add_column :foods, :iron, :float

    Food.find_each do |food|
      food.vitamin_a = UsdaNdb::DailyValues.new('Vitamin A').value_from_percent_daily(food.dv_vitamin_a / 100).scalar if food.dv_vitamin_a
      food.vitamin_c = UsdaNdb::DailyValues.new('Vitamin C').value_from_percent_daily(food.dv_vitamin_c / 100).scalar if food.dv_vitamin_c
      food.calcium   = UsdaNdb::DailyValues.new('Calcium').value_from_percent_daily(food.dv_calcium / 100).scalar if food.dv_calcium
      food.iron      = UsdaNdb::DailyValues.new('Iron').value_from_percent_daily(food.dv_iron / 100).scalar if food.dv_iron
    end
  end

  def self.down
    remove_column :foods, :iron
    remove_column :foods, :calcium
    remove_column :foods, :vitamin_c
    remove_column :foods, :vitamin_a
  end
end
