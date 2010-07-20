class ListItem < ActiveRecord::Base
  belongs_to :list
  belongs_to :food
  belongs_to :recipe

  validates_presence_of :name

  validate :qty_is_a_unit

  def qty_is_a_unit
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
  private :qty_is_a_unit

  def measure(nutrient)
    food.try(:measure, nutrient, qty)
  end

  def daily_value(nutrient)
    food.try(:daily_value, nutrient, qty)
  end
end