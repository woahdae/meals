class AddPolymorphicSourceToFoods < ActiveRecord::Migration
  def self.up
    add_column :foods, :source_type, :string
    add_column :foods, :source_id, :string

    UserFood.find_each {|food| food.source = food.user;food.save}
    UsdaNdbFood.find_each {|food| food.source = food.usda_abbreviated_data}
  end

  def self.down
    remove_column :foods, :source_id
    remove_column :foods, :source_type
  end
end
