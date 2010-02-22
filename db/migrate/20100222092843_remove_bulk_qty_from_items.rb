class RemoveBulkQtyFromItems < ActiveRecord::Migration
  def self.up
    remove_column :items, :bulk_qty
    remove_column :items, :bulk_qty_unit
  end

  def self.down
    add_column :items, :bulk_qty_unit, :string
    add_column :items, :bulk_qty, :float
  end
end
