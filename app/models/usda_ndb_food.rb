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

    standard_unit = common_weight_description.split(",").first.to_unit

    common_weight * standard_unit.scalar * amount.convert_to(standard_unit.units).scalar
  end

  def measure(nutrient, amount = nil)
    begin
      if amount && self.send(nutrient)
        amount = volume_to_weight(amount)
        (self.send(nutrient) / grams_per_nutrient) * amount
      else
        self.send(nutrient)
      end
    end.try(:scalar)
  end
end