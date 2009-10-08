class Item < ActiveRecord::Base
  belongs_to :recipe
  acts_as_unitable :bulk_qty, :amount
  
  validates_presence_of :amount, :amount_unit
  
  def dollars_per_base_unit
    self.bulk_price.to_unit('dollar') / self.bulk_qty_with_unit.to_base
  end
  
  def dollars_per_amount
    self.dollars_per_base_unit.convert_to("USD/#{self.amount_unit}")
  end
  
  def cost
    self.amount_with_unit.to_base * self.dollars_per_base_unit
  end
end
