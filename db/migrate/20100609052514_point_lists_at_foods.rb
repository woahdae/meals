class PointListsAtFoods < ActiveRecord::Migration
  def self.up
    create_table :foods_lists, :force => true, :id => false do |t|
      t.integer :food_id
      t.integer :list_id
    end

    add_index :foods_lists, [:food_id, :list_id]
  end

  def self.down
    remove_index :item_uids_lists, [:food_id, :list_id]
    drop_table :foods_lists
  end
end
