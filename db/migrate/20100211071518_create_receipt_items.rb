class CreateReceiptItems < ActiveRecord::Migration
  def self.up
    create_table :receipt_items do |t|
      t.integer :item_uid_id
      t.string :name
      t.decimal :price
      t.float :qty
      t.string :qty_unit
      t.integer :receipt_id
      
      t.timestamps
    end
    
    add_index :receipt_items, :item_uid_id
    add_index :receipt_items, :receipt_id
  end

  def self.down
    remove_index :receipt_items, :receipt_id
    remove_index :receipt_items, :item_uid_id
    drop_table :receipt_items
  end
end
