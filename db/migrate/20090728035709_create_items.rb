class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name
      t.float :amount
      t.string :amount_unit
      t.decimal :bulk_price, :precision => 10, :scale => 2
      t.float :bulk_qty
      t.string :bulk_qty_unit
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
