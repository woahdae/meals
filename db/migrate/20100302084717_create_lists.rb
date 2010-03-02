class CreateLists < ActiveRecord::Migration
  def self.up
    create_table :lists do |t|
      t.integer :user_id
      
      t.timestamps
    end
    
    add_index :lists, :user_id

    create_table :lists_recipes, :id => false do |t|
      t.integer :recipe_id
      t.integer :list_id
    end
    
    add_index :lists_recipes, [:recipe_id, :list_id]
    
    create_table :item_uids_lists, :id => false do |t|
      t.integer :item_uid_id
      t.integer :list_id
    end
    
    add_index :item_uids_lists, [:item_uid_id, :list_id]
  end

  def self.down
    remove_index :lists_recipes, [:recipe_id, :list_id]
    remove_index :item_uids_lists, [:item_uid_id, :list_id]
    drop_table :item_uids_lists
    drop_table :lists_recipes
    remove_index :lists, :user_id
    drop_table :lists
  end
end
