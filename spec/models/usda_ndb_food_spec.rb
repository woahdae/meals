require 'spec_helper'
require 'models/food_spec'

describe UsdaNdbFood do
  subject { UsdaNdbFood.new(
    :kcal => 500,
    :common_weight => 250,
    :common_weight_description => "1 cup")}
  
  context "" do
    before {@food = subject}
    it_should_behave_like "All food"
  end
  
  describe "#measure" do
    it "returns the number of a nutrient given a volume" do
      # (500 kcal/100g * 250 g/cup) = (5 kcal/g * 250 g/cup) = 1250 kcal/cup
      subject.measure(:kcal, "2 cups").should == 2500
    end
  end

  describe "#average_unit_price" do
    let(:receipt_items) {[
      mock_model(ReceiptItem, :price => 10.00, :qty => "1 cup"),
      mock_model(ReceiptItem, :price => 5.00, :qty => "250 grams")
    ]}

    before {subject.receipt_items = receipt_items}

    it "uses receipt items to find the average price per unit" do
      subject.average_unit_price.unit.should eq_unit("7.50 USD/cup")
    end
  end

  describe "#common_volume" do
    it "parses a volume unit out of common_weight_description" do
      subject.common_weight_description = "1 cup, sliced"
      subject.common_volume.should eq_unit("1 cup")
    end

    it "returns nil if unable to parse a volume unit" do
      subject.common_weight_description = "1 pepper"
      subject.common_volume.should be_nil
    end
  end

end