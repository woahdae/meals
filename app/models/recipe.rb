class Recipe < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  accepts_nested_attributes_for :items
  
  def cost
    self.items.inject(0.dollars) do |price, item|
      item_dollars_per_pound = (item.bulk_price.dollars / item.bulk_qty.to_pounds)
      item_price_in_dollars = item.amount.to_pounds * item_dollars_per_pound
      # thinks we wanted pounds; units doesn't understand "dollars per pound"
      item_price_in_dollars.instance_variable_set(:@unit, :dollars)
      price += item_price_in_dollars
    end
  end
  
  def price_per_serving
    self.cost / self.servings
  end
end
