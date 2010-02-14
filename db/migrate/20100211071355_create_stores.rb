class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.string :street
      t.string :state
      t.string :city
      t.string :zip
      t.string :name
      t.integer :chain_id

      t.timestamps
    end
    
    add_index :stores, :chain_id
  end

  def self.down
    remove_index :stores, :chain_id
    drop_table :stores
  end
end
