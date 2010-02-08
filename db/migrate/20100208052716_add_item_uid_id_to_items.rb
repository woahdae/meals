class AddItemUidIdToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :item_uid_id, :integer
    add_index :items, :item_uid_id
  end

  def self.down
    remove_index :items, :item_
    remove_column :items, :item_uid_id
  end
end
