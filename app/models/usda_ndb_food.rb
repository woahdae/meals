class UsdaNdbFood < Food
  belongs_to :usda_abbreviated_data, :class_name => "UsdaNdb::AbbreviatedData", :foreign_key => "usda_ndb_id"
  belongs_to :usda_food_description, :class_name => "UsdaNdb::FoodDescription", :foreign_key => "usda_ndb_id"

  def common_measure
    common_volume || common_weight
  end

  def grams_per_nutrient
    100.to_unit("grams")
  end
end