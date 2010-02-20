class ChangeDecimalScaleForReceiptItemsPrice < ActiveRecord::Migration
  def self.up
    change_column(:receipt_items, :price, :decimal, :precision => 10, :scale => 2)
  end

  def self.down
    change_column(:receipt_items, :price, :decimal)
  end
end
