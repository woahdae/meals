class AddNutrientsToFood < ActiveRecord::Migration
  def self.up
    add_column :foods, :serving_size, :string
    add_column :foods, :servings, :integer
    add_column :foods, :fat_kcal, :float
    add_column :foods, :sodium, :float
    add_column :foods, :dv_vitamin_a, :integer
    add_column :foods, :dv_vitamin_c, :integer
    add_column :foods, :dv_calcium, :integer
    add_column :foods, :dv_iron, :integer
  end

  def self.down
    remove_column :foods, :serving_size
    remove_column :foods, :servings
    remove_column :foods, :dv_iron
    remove_column :foods, :dv_calcium
    remove_column :foods, :dv_vitamin_c
    remove_column :foods, :dv_vitamin_a
    remove_column :foods, :sodium
    remove_column :foods, :fat_kcal
  end
end
