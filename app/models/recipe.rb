class Recipe < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  accepts_nested_attributes_for :items
  
  validates_numericality_of :servings, :greater_than => 0
  
  def cost
    price = self.items.inject(0.to_unit('dollar')) do |price, item|
      item_dollars_per_pound = item.bulk_price.to_unit('dollar') / item.bulk_qty_with_unit.convert_to('lbs')
      item_price_in_dollars = item.amount_with_unit.convert_to('lbs') * item_dollars_per_pound
      price += item_price_in_dollars
    end
    
    return price.scalar.to_f
  end
  
  def price_per_serving
    (self.cost / self.servings).to_f
  end
  
  # finds the maximum amount you could make using up all of the bulk quantities.
  def servings_from_bulk
    self.items.inject(999999) do |floor, item|
      return nil unless item.bulk_qty_with_unit && item.amount_with_unit
      
      floor_contender = item.bulk_qty_with_unit.convert_to('lbs') / item.amount_with_unit.convert_to('lbs')
      [floor, floor_contender.scalar].min.floor
    end
  end
end
