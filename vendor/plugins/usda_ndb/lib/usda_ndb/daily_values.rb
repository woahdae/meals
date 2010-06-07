class UsdaNdb::DailyValues
  attr_reader :daily_value

  def initialize(nutrient)
    @daily_value = DAILY_VALUES[nutrient].try(:to_unit)
    raise ArgumentError, "Unknown nutrient '#{nutrient}'" if @daily_value.nil?
  end

  # Based on a 2,000 kcal diet
  DAILY_VALUES = {
    "Biotin" => "300 micrograms",
    "Calcium" => "1000 milligrams",
    "Chloride" => "3400 milligrams",
    "Cholesterol" => "300 milligrams",
    "Chromium" => "120 micrograms",
    "Copper" => "2 milligrams",
    "Dietary fiber" => "25 grams",
    "Folate" => "400 micrograms",
    "Iodine" => "150 micrograms",
    "Iron" => "18 milligrams",
    "Magnesium" => "400 milligrams",
    "Manganese" => "2 milligrams",
    "Molybdenum" => "75 micrograms",
    "Niacin" => "20 milligrams",
    "Pantothenic acid" => "10 milligrams",
    "Phosphorus" => "1000 milligrams",
    "Potassium" => "3500 milligrams",
    "Protein" => "50 grams",
    "Riboflavin" => "1.7 milligrams",
    "Saturated fat" => "20 grams",
    "Selenium" => "70 micrograms",
    "Sodium" => "2400 milligrams",
    "Thiamin" => "1.5 milligrams",
    "Total carbohydrate" => "300 grams",
    "Total fat" => "65 grams",
    "Vitamin A" => "5000 IU",
    "Vitamin B-12" => "6 micrograms",
    "Vitamin B-6" => "2 milligrams",
    "Vitamin C" => "60 milligrams",
    "Vitamin D" => "400 IU",
    "Vitamin E" => "30 IU",
    "Vitamin K" => "80 micrograms",
    "Zinc" => "15 milligrams"
  }

  def percent_daily_value(amount)
    (amount.to_unit / @daily_value).scalar
  end

  def value_from_percent_daily(dv)
    @daily_value * dv
  end
end