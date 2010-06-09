class PointReceiptItemToFood < ActiveRecord::Migration
  def self.up
    add_column :receipt_items, :food_id, :string
    add_index :receipt_items, :food_id
    
    ReceiptItem.find_each(:include => :uid) do |item|
      if item.uid
        item.food = Food.find_by_usda_ndb_id(item.uid.usda_ndb_id)
        item.save
      end
    end
  end

  def self.down
    remove_index :receipt_items, :food_id
    remove_column :receipt_items, :food_id
  end
end
