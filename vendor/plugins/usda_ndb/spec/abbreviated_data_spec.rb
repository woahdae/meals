require 'spec_helper'

describe UsdaNdb::AbbreviatedData do
  before do
    # This would mean:
    # * 500 kcal per 100g
    # * 250 grams per 1 cup
    @data = UsdaNdb::AbbreviatedData.new(
      :kcal => 500,
      :weight_1 => 250,
      :weight_1_description => "1 cup"
    )
  end
  
  it "converts volume to weight" do
    # 1 pint = 2 cups
    @data.volume_to_weight("1 pint").to_s.should == "500 g"
  end
  
  it "converts volume to weight for weight descriptions with extra data" do
    @data.weight_1_description = "1 tbsp, whole"
    @data.volume_to_weight("1 tsp").to_s.should == "83.3333 g"
  end
  
  it "measures the number of a nutrient given a metric weight" do
    # (nutrient content per 100g) * (grams per common measure) / 100
    # (500 kcal/100g * 8 g) = 40 kcal
    @data.measure(:kcal, "8 grams").should == 40
  end

  it "measures the number of a nutrient given a standard weight" do
    # (nutrient content per 100g) * (grams per common measure) / 100
    # (500 kcal/100g * 8 g) = 40 kcal
    @data.measure(:kcal, "8 oz").to_i.should == 1133
  end

  it "measures the number of a nutrient given a volume" do
    # (nutrient content per 100g) * (grams per common measure) / 100
    # (500 kcal/100g * 250 g/cup) = (5 kcal/g * 250 g/cup) = 1250 kcal/cup
    @data.measure(:kcal, "2 cups").should == 2500
  end
end