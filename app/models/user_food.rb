class UserFood < Food
  belongs_to :user

  validates_format_of :name, :with => /,/, 
    :message => %(should be in 'tag' format from most generic to most specific, ex: "burrito, chicken fajita, trader joes")
  validates_presence_of :servings

  validate :serving_size_is_a_unit

  def serving_size_is_a_unit
    begin
      if serving_size
        errors.add(:serving_size, "must contain a unit (ex. #{self[:serving_size]} grams)") if serving_size.units.blank?
      else
        errors.add(:serving_size, "must be specified")
      end
    rescue => e
      if e.message.include?("Unit not recognized")
        errors.add(:serving_size, "'#{self[:serving_size]}' is not a valid unit")
      else
        raise
      end
    end
  end
  private :serving_size_is_a_unit

  def measure(nutrient, amount = nil)
    if amount && self.send(nutrient)
      amount = amount.to_unit.convert_to('grams')
      self.send(nutrient) / grams_per_nutrient * amount
    else
      self.send(nutrient)
    end
  end

  def qty
    serving_size * servings
  end

  def grams_per_nutrient
    serving_size
  end

  def serving_size
    self[:serving_size].try(:to_unit)
  end

  def average_price_per_serving
    return nil if average_price.nil?

    average_price(qty) / servings
  end
end