class CreateItemUids < ActiveRecord::Migration
  def self.up
    create_table :item_uids do |t|
      t.integer :usda_ndb_id
      t.integer :our_ndb_id
    end
    
    add_index :item_uids, :usda_ndb_id
    add_index :item_uids, :our_ndb_id
  end

  def self.down
    remove_index :item_uids, :our_ndb_id
    remove_index :item_uids, :usda_ndb_id
    drop_table :item_uids
  end
end
