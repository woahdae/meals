require 'spec_helper.rb'

describe UsdaNdb::DailyValues do
  context "with a valid nutrient" do
    subject {
      UsdaNdb::DailyValues::DAILY_VALUES['Vitamin C'] = "60 milligrams"
      UsdaNdb::DailyValues.new('Vitamin C')
    }

    describe "::percent_daily_value" do
      it "returns a percentage (as a float) for the daily value of a given nutrient for a given amount" do
        subject.percent_daily_value("30 milligrams")\
          .should be_close(0.5, 0.01)
      end
    end
    
    describe "::value_from_percent_daily" do
      it "returns a unit for the amount of a given nutrient for a given daily value (as a floating-point percent)" do
        subject.value_from_percent_daily(0.5)\
          .should == "30 milligrams".to_unit
      end
    end
  end

  context "with an unknown nutrient" do
    subject {
      UsdaNdb::DailyValues.new('Vitamin Xtreme')
    }
    
    describe "::percent_daily_value" do
      it "returns nil if it can't find the nutrient" do
        subject.percent_daily_value("anything").should be_nil
      end
    end
    
    describe "::value_from_percent_daily" do
      it "returns nil if it can't find the nutrient" do
        subject.value_from_percent_daily("anything").should be_nil
      end
    end
  end

  context "Vitamin A" do
    subject { UsdaNdb::DailyValues.new("Vitamin A") }

    it "recognizes IU as a valid unit" do
      subject.value_from_percent_daily(1).units.should == "IU"
    end
  end
end