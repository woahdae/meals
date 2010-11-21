require 'spec_helper'

describe Food do
  subject do
    Food.new(
      :kcal => 500,
      :servings => 1,
      :serving_size => "100 grams",
      :common_weight => 250,
      :common_weight_description => "1 cup")
  end

  context "validation" do
    subject do
      Food.new(
        :name => "burrito, chicken fajita, trader joes",
        :servings => 2,
        :serving_size => "280 grams",
        :kcal => "1.5",
        :fat => "1.5",
        :saturated_fat => "1.5",
        :monounsaturated_fat => "1.5",
        :polyunsaturated_fat => "1.5",
        :cholesterol => "1.5",
        :carbs => "1.5",
        :protein => "1.5",
        :sugar => "1.5",
        :fiber => "1.5" )
    end

    it "passes when given valid attributes" do
      subject.should be_valid
    end

    it "fails when names are not tag formatted" do
      subject.name = "chicken fajita burrito"
      subject.should_not be_valid
      subject.errors[:name].first.should include("should be in 'tag' format from most generic to most specific")
    end

    it "fails when quantity does not contain a unit" do
      subject.serving_size = "5"
      subject.should_not be_valid
      subject.errors[:serving_size].should_not be_empty
    end

    it "fails when quantity is not a unit" do
      subject.serving_size = "5 garbles"
      subject.should_not be_valid
      subject.errors[:serving_size].should_not be_empty
    end

    it "fails when servings is nil" do
      subject.servings = nil
      subject.should_not be_valid
      subject.errors[:servings].should_not be_empty
    end

    it "fails when serving_size is nil" do
      subject.serving_size = nil
      subject.should_not be_valid
      subject.errors[:serving_size].should_not be_empty
    end
  end

  describe "#measure" do
    it "calculates the number of a nutrient given a metric weight" do
      # (nutrient content per 100g) * (grams per common measure) / 100
      # (500 kcal/100g * 8 g) = 40 kcal
      subject.measure(:kcal, "8 grams").should == 40
    end

    it "calculates the number of a nutrient given a standard weight" do
      # (nutrient content per 100g) * (grams per common measure) / 100
      # (500 kcal/100g * 28.35 g/oz * 8 oz) ~= 1133 kcal
      subject.measure(:kcal, "8 oz").to_i.should == 1133
    end

    it "calculates the number of a nutrient given a volume" do
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

  describe "#average_price_per_serving" do
    it "uses average price and servings to calculate" do
      food = Food.new(:servings => 2, :serving_size => "170 grams")
      food.stub!(:average_price).and_return(5.00)
      food.average_price_per_serving.should == 2.5
    end

    it "returns nil if average_price is nil" do
      food = Food.new(:servings => 2, :serving_size => "170 grams")
      food.stub!(:average_price).and_return(nil)
      food.average_price_per_serving.should be_nil
    end
  end

  describe "#average_price" do
    subject { Food.new(
      :common_weight => 250,
      :common_weight_description => "1 cup")}

    let(:receipt_items) {[
      mock_model(ReceiptItem, :price => 10.00, :qty => "1 cup"),
      mock_model(ReceiptItem, :price => 5.00, :qty => "250 grams")
    ]}

    before {subject.receipt_items = receipt_items}

    it "uses receipt items to find the average price for a given amount" do
      subject.average_price("500 grams").should eq_unit("15 USD")
    end
  end

end
