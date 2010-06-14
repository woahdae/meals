class ReceiptItem < ActiveRecord::Base
  belongs_to :food
  belongs_to :receipt

  validates_presence_of :name, :price, :qty

  def validate
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

  def price_per_base_unit
    self.price.to_unit('dollar') / self.qty.to_unit.to_base
  end
end
