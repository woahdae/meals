class Item < ActiveRecord::Base
  
  belongs_to :recipe
  belongs_to :uid, :class_name => "ItemUID", :foreign_key => "item_uid_id"
  has_many :receipt_items, :primary_key => "item_uid_id", :foreign_key => "item_uid_id"

  validates_presence_of :name
  validates_presence_of :amount, :amount_unit

  acts_as_unitable :amount
  validates_as_unit :amount, :allow_blank => true

  def average_price_per_base_unit
    return nil if receipt_items.empty?
    
    receipt_items.collect(&:price_per_base_unit).sum / receipt_items.size
  end
  
  def average_price_per_amount
    return nil if average_price_per_base_unit.nil?
    
    average_price_per_base_unit.convert_to("USD/#{self.qty.to_unit.units}")
  end
  
  def average_price
    return nil if average_price_per_base_unit.nil? || amount_with_unit.nil?

    amount_with_unit.to_base * average_price_per_base_unit
  end
end
