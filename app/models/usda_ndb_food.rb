class UsdaNdbFood < Food
  belongs_to :usda_abbreviated_data, :class_name => "UsdaNdb::AbbreviatedData", :foreign_key => "usda_ndb_id"
  belongs_to :usda_food_description, :class_name => "UsdaNdb::FoodDescription", :foreign_key => "usda_ndb_id"

  def qty
    raise 'unknown'
  end

  def measure(nutrient, amount = nil)
    if amount && self.send(nutrient)
      (self.send(nutrient) / grams_per_nutrient) * 
        UnitWithDensity.new(amount, :density => density)\
        .convert_to('grams').scalar
    else
      self.send(nutrient)
    end
  end

  def grams_per_nutrient
    100
  end

  def common_volume
    return nil if common_weight_description.nil?
    
    common_weight_description.split(",").first.to_unit
  rescue => e
    if e.message.include?('Unit not recognized')
      return nil
    else
      raise
    end
  end
end