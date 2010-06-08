class PointItemsAtFoods < ActiveRecord::Migration
  def self.up
    add_column :items, :food_id, :integer
    add_index :items, :food_id
    
    Item.find_each(:include => :uid) do |item|
      if item.uid
        item.food = Food.find_by_usda_ndb_id(item.uid.usda_ndb_id)
        item.save
      end
    end
  end

  def self.down
    remove_index :items, :food_id
    remove_column :items, :food_id
  end
end
