class Item < ActiveRecord::Base
  
  belongs_to :recipe
  belongs_to :uid, :class_name => "ItemUID", :foreign_key => "item_uid_id"
  acts_as_unitable :bulk_qty, :amount

  validates_presence_of :name
  validates_presence_of :amount, :amount_unit

  validates_as_unit :bulk_qty, :amount, :allow_blank => true

  def dollars_per_base_unit
    raise IncalculableMetricError.new("dollars_per_base_unit missing bulk price") if self.bulk_price.nil?
    
    self.bulk_price.to_unit('dollar') / self.bulk_qty_with_unit.to_base
  end
  
  def dollars_per_amount
    self.dollars_per_base_unit.convert_to("USD/#{self.amount_unit}")
  end
  
  def cost
    raise IncalculableMetricError.new('amount_with_unit nil') if self.amount_with_unit.nil?
    
    self.amount_with_unit.to_base * self.dollars_per_base_unit
  end
end
