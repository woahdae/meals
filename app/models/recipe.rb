class Recipe < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  accepts_nested_attributes_for :items
  
  validates_numericality_of :servings, :greater_than => 0
  
  def cost
    price = self.items.inject(0.to_unit('dollar')) do |price, item|
      item_price_in_dollars = item.amount_with_unit.to_base * item.dollars_per_base_unit
      price += item_price_in_dollars
    end
    
    return price.scalar.to_f
  end
  
  def price_per_serving
    (self.cost / self.servings).to_f
  end

  def bulk_cost
    self.items.inject(0.0) {|sum, item| sum += item.bulk_price}.round(2)
  end
  
  # finds the maximum amount you could make using up all of the bulk quantities.
  def servings_from_bulk
    self.items.inject(999999) do |floor, item|
      return nil unless item.bulk_qty_with_unit && item.amount_with_unit
      
      floor_contender = item.bulk_qty_with_unit.to_base / item.amount_with_unit.to_base
      [floor, floor_contender.scalar].min.floor
    end
  end
end
