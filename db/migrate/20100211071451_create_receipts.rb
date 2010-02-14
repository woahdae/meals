class CreateReceipts < ActiveRecord::Migration
  def self.up
    create_table :receipts do |t|
      t.integer :user_id
      t.integer :store_id

      t.timestamps
    end
    
    add_index :receipts, :user_id
    add_index :receipts, :store_id
  end

  def self.down
    remove_index :receipts, :store_id
    remove_index :receipts, :user_id
    mind
    drop_table :receipts
  end
end
