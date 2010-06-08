class PointItemsAtFoods < ActiveRecord::Migration
  def self.up
    add_column :items, :food_id, :integer
    add_index :items, :food_id
    
    Item.find_each do |item|
      item.food = Food.find_by_usda_ndb_id(item.item_uid_id)
      item.save
    end
  end

  def self.down
    remove_index :items, :food_id
    remove_column :items, :food_id
  end
end
