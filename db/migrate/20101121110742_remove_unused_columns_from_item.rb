class RemoveUnusedColumnsFromItem < ActiveRecord::Migration
  def self.up
    remove_column :items, :bulk_price
    remove_column :items, :calories
    remove_column :items, :fat
    remove_column :items, :carbs
    remove_column :items, :protein
  end

  def self.down
    add_column :items, :protein, :float
    add_column :items, :carbs, :float
    add_column :items, :fat, :float
    add_column :items, :calories, :integer
    add_column :items, :bulk_price, :decimal,  :precision => 10, :scale => 2
  end
end
