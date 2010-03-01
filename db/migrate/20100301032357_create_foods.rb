class CreateFoods < ActiveRecord::Migration
  def self.up
    create_table :foods do |t|
      t.string :name
      t.float :kcal
      t.float :fat
      t.float :saturated_fat
      t.float :monounsaturated_fat
      t.float :polyunsaturated_fat
      t.float :cholesterol
      t.float :carbs
      t.float :protein
      t.float :sugar
      t.float :fiber

      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :foods
  end
end
