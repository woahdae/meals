class AddFoodIdToItemUid < ActiveRecord::Migration
  def self.up
    remove_index :item_uids, :our_ndb_id
    rename_column :item_uids, :our_ndb_id, :food_id
    add_index :item_uids, :food_id
  end

  def self.down
    remove_index :item_uids, :food_id
    rename_column :item_uids, :food_id, :our_ndb_id
    add_index :item_uids, :our_ndb_id
  end
end
