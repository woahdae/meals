class CreateRecipes < ActiveRecord::Migration
  def self.up
    create_table :recipes do |t|
      t.string :name
      t.float :prep_time
      t.float :cook_time
      t.integer :servings
      t.text :directions

      t.timestamps
    end
  end

  def self.down
    drop_table :recipes
  end
end
