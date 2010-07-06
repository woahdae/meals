class ReceiptItem < ActiveRecord::Base
  belongs_to :food
  belongs_to :receipt

  validates_presence_of :name, :price, :qty

  validate :qty_is_a_unit

  def qty_is_a_unit
    begin
      errors.add(:qty, "must contain a unit (ex. #{qty} lbs)") if qty.to_unit.units.blank?
    rescue => e
      if e.message.include?("Unit not recognized")
        errors.add(:qty, "'#{qty}' is not a valid unit")
      else
        raise
      end
    end
  end
  private :qty_is_a_unit

  def unit_price
    CompoundUnit.new(
      :numerator => price.to_unit('dollar'),
      :denominator => qty.to_unit
    )
  end
end
