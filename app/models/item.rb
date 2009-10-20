class Item < ActiveRecord::Base
  
  belongs_to :recipe
  acts_as_unitable :bulk_qty, :amount

  validates_presence_of :name
  validates_presence_of :amount, :amount_unit

  validates_as_unit :bulk_qty, :amount
  
  # TODO: remove this validation. currently throws an error if these are nil, but that's not desired
  validates_presence_of :bulk_qty_unit, :message => "not given", :if => Proc.new {|obj| !obj.bulk_qty.nil?}
  
  def dollars_per_base_unit
    raise IncalculableMetricError.new("dollars_per_base_unit missing bulk price") if self.bulk_price.nil?
    
    self.bulk_price.to_unit('dollar') / self.bulk_qty_with_unit.to_base
  end
  
  def dollars_per_amount
    self.dollars_per_base_unit.convert_to("USD/#{self.amount_unit}")
  end
  
  def cost
    self.amount_with_unit.to_base * self.dollars_per_base_unit
  end
end
