class AddFoodIdToItemUid < ActiveRecord::Migration
  def self.up
    rename_column :item_uids, :our_ndb_id, :food_id
  end

  def self.down
    rename_column :item_uids, :food_id, :our_ndb_id
  end
end
