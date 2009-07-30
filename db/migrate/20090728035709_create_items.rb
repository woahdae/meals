class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name
      t.string :amount
      t.decimal :bulk_price
      t.float :bulk_qty
      t.integer :calories
      t.float :fat
      t.float :carbs
      t.float :protein
      t.integer :recipe_id

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
