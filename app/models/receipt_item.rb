class ReceiptItem < ActiveRecord::Base
  belongs_to :uid, :class_name => "ItemUID", :foreign_key => "item_uid_id"
  belongs_to :receipt
  
  
  validates_presence_of :name, :price
  
  acts_as_unitable :qty
  validates_as_unit :qty
  
  def price_per_base_unit
    self.price.to_unit('dollar') / self.qty.to_unit.to_base
  end
  
end
