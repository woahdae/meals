require 'spec_helper'

shared_examples_for "All food" do
  # in the before, we need a food with a kcal content
  # in units per 100 grams
  
  it "measures the number of a nutrient given a metric weight" do
    # (nutrient content per 100g) * (grams per common measure) / 100
    # (500 kcal/100g * 8 g) = 40 kcal
    @food.measure(:kcal, "8 grams").should == 40
  end

  it "measures the number of a nutrient given a standard weight" do
    # (nutrient content per 100g) * (grams per common measure) / 100
    # (500 kcal/100g * 28.35 g/oz * 8 oz) ~= 1133 kcal
    @food.measure(:kcal, "8 oz").to_i.should == 1133
  end
end

describe Food do
  context "nutrient attributes" do
    let(:attribute) {Food::NUTRIENT_ATTRIBUTES.keys.first}
    it "overwrite the default readers to instantiate Nutrient objects" do
      subject.send(attribute).class.should == Nutrient
    end

    it "overwrite the default writers to filter through Nutrient objects" do
      subject.send("#{attribute}=", 3000)
      subject.send(attribute).value.should == 3000
    end

    it "adds a reader for attribute_daily_value" do
      # I'm tired...
      subject.send("#{attribute}_daily_value").should == 0
    end

    it "adds an attribute_daily_value= writer" do
      subject.send("#{attribute}_daily_value=", 100.0)
      subject.send("#{attribute}_daily_value").should be_close(100.0, 0.01)
    end
  end
end
