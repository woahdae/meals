class RemoveDailyValueNutrientsFromFoods < ActiveRecord::Migration
  def self.up
    remove_column :foods, :dv_vitamin_a
    remove_column :foods, :dv_vitamin_c
    remove_column :foods, :dv_calcium
    remove_column :foods, :dv_iron
  end

  def self.down
    add_column :foods, :dv_iron, :integer
    add_column :foods, :dv_calcium, :integer
    add_column :foods, :dv_vitamin_c, :integer
    add_column :foods, :dv_vitamin_a, :integer
  end
end
