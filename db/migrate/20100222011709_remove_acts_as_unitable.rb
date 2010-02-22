class RemoveActsAsUnitable < ActiveRecord::Migration
  def self.up
    add_column :items, :string_qty, :string
    add_column :receipt_items, :string_qty, :string
    
    Item.find_each do |item|
      item.update_attribute(:string_qty, item.amount_with_unit.scalar.round(4).to_s + " " + item.amount_unit)
    end
    
    ReceiptItem.find_each do |item|
      item.update_attribute(:string_qty, item.qty_with_unit.scalar.round(4).to_s + " " + item.qty_unit)
    end
    
    remove_column :receipt_items, :qty
    remove_column :items, :amount
    remove_column :receipt_items, :qty_unit
    remove_column :items, :amount_unit
    
    rename_column :receipt_items, :string_qty, :qty
    rename_column :items, :string_qty, :qty
  end

  def self.down
    add_column :items, :amount_unit, :string
    add_column :receipt_items, :qty_unit, :string
    rename_column :items, :qty, :string_qty
    rename_column :receipt_items, :qty
    rename_column :items, :string_qty
    remove_column :receipt_items, :qty
    remove_column :receipt_items, :string_qty
    remove_column :items, :string_amount
    add_column :receipt_items, :qty, :float
    add_column :items, :amount, :float
  end
end
