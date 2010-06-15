require 'spec_helper'
require 'models/food_spec'

describe UsdaNdbFood do
  context "" do
    before do
      # This would mean:
      # * 500 kcal per 100g
      # * 250 grams per 1 cup
      @food = UsdaNdbFood.new(
        :kcal => 500,
        :common_weight => 250,
        :common_weight_description => "1 cup"
      )
    end

    it_should_behave_like "All food"

    it "measures the number of a nutrient given a volume" do
      # (nutrient content per 100g) * (grams per common measure) / 100
      # (500 kcal/100g * 250 g/cup) = (5 kcal/g * 250 g/cup) = 1250 kcal/cup
      @food.measure(:kcal, "2 cups").should == 2500
    end

    it "converts volume to weight" do
      # 1 pint = 2 cups
      @food.volume_to_weight("1 pint").to_s.should == "500 g"
    end

    it "converts volume to weight for weight descriptions with extra data" do
      @food.common_weight_description = "1 tbsp, whole"
      @food.volume_to_weight("1 tsp").to_s.should == "83.3333 g"
    end
  end

  describe "#common_measure" do
    it "parses a volume unit out of common_weight_description" do
      subject.common_weight_description = "1 cup, sliced"
      subject.common_measure.should == "1 cup".to_unit
    end

    it "returns nil if unable to parse a volume unit" do
      subject.common_weight_description = "1 pepper"
      subject.common_measure.should be_nil
    end
  end
end