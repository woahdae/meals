class UsdaNdb::AbbreviatedData < ActiveRecord::Base
  establish_connection(UsdaNdb::configurations[Rails.env])
  set_primary_key :ndb_no
  set_table_name :abbreviated_data
  
  def measure(metric, amount)
    amount = volume_to_weight(amount)
    
    # metrics are in thing/100g.
    # ruby-units doesn't recognize ex. kcal as a unit though, so we'll leave
    # that out in the calculation and grab the scalar at the end
    return (((self.send(metric) || 0) / 100) * amount.convert_to("grams")).scalar
  end
  
  # self.weight_1 refers to how many grams are in self.weight_1_description
  # This uses those to convert volume to weight (in grams). Returns a Unit (not a float)
  def volume_to_weight(amount)
    amount = amount.to_unit
    return amount if amount.to_base.units == "kg"
    
    standard_unit = weight_1_description.split(",").first.to_unit
    
    # standard_unit.scalar is usually 1, but just in case we'll use the actual value
    weight_1.to_unit("grams") * standard_unit.scalar * amount.convert_to(standard_unit.units).scalar
  end
end