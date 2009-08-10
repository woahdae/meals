class Recipe < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  accepts_nested_attributes_for :items
  
  def cost
    price = self.items.inject(0.to_unit('dollar')) do |price, item|
      item_dollars_per_pound = item.bulk_price.to_unit('dollar') / item.bulk_qty_with_unit.convert_to('lbs')
      item_price_in_dollars = item.amount_with_unit.convert_to('lbs') * item_dollars_per_pound
      price += item_price_in_dollars
    end
    
    return price.scalar
  end
  
  def price_per_serving
    (self.cost / self.servings).to_f
  end
end
