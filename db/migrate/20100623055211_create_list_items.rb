class CreateListItems < ActiveRecord::Migration
  def self.up
    create_table :list_items, :force => true do |t|
      t.integer :list_id
      t.integer :food_id
      t.integer :recipe_id
      t.string  :qty
      t.string  :name

      t.timestamps
    end

    add_index :list_items, :list_id
    add_index :list_items, :food_id
    add_index :list_items, :recipe_id

    drop_table :lists_recipes
    drop_table :foods_lists
  end

  def self.down
    create_table "foods_lists", :id => false, :force => true do |t|
      t.integer "food_id"
      t.integer "list_id"
    end
    
    create_table "lists_recipes", :id => false, :force => true do |t|
      t.integer "recipe_id"
      t.integer "list_id"
    end
    
    remove_index :list_items, :recipe_id
    remove_index :list_items, :food_id
    remove_index :list_items, :list_id
    drop_table :list_items
  end
end
