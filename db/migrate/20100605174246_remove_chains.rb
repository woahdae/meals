class RemoveChains < ActiveRecord::Migration
  def self.up
    drop_table :chains
    remove_column :stores, :chain_id
  end

  def self.down
    add_column :stores, :chain_id, :integer
    create_table "chains", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
