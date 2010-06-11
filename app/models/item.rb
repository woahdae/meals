class Item < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :food
  
  delegate :average_price_per_base_unit, :to => :food, :allow_nil => true

  validates_presence_of :name
  validates_presence_of :qty

  def validate
    begin
      errors.add(:qty, "must contain a unit (ex. #{qty} lbs)") if qty.present? && qty.to_unit.units.blank?
    rescue => e
      if e.message.include?("Unit not recognized")
        errors.add(:qty, "'#{qty}' is not a valid unit")
      else
        raise
      end
    end
  end

  def measure(nutrient)
    food.try(:measure, nutrient, qty)
  end
  
  def average_price
    food.try(:average_price, qty)
  end
  
  def average_price_per_amount
    food.try(:average_price_per_amount, qty)
  end
end









