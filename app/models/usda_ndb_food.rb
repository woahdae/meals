class UsdaNdbFood < Food
  belongs_to :usda_abbreviated_data, :class_name => "UsdaNdb::AbbreviatedData", :foreign_key => "usda_ndb_id"
  belongs_to :usda_food_description, :class_name => "UsdaNdb::FoodDescription", :foreign_key => "usda_ndb_id"

  def qty
    raise 'unknown'
  end

  def grams_per_nutrient
    100
  end

  # hopefully we can figure out how to get user food to do this too
  def volume_to_weight(amount)
    amount = amount.to_unit
    return amount.convert_to('grams') if amount.to_base.units == "kg"

    common_weight * common_measure.scalar * amount.convert_to(common_measure.units).scalar
  end

  def common_measure
    return nil if common_weight_description.nil?
    
    common_weight_description.split(",").first.to_unit
  end

  def measure(nutrient, amount = nil)
    value = if amount && self.send(nutrient)
      amount = volume_to_weight(amount)
      (self.send(nutrient) / grams_per_nutrient) * amount
    else
      self.send(nutrient)
    end

    value.respond_to?(:scalar) ? value.scalar : value
  end

  def average_price_per_common_measure
    return nil if common_measure.nil?
    
    average_price_per_unit(common_measure)
  end
end