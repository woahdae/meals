require 'spec_helper'

describe UserFood do
  context "validation" do
    before(:each) do
      @food = UserFood.new({
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
        :fiber => "1.5"
      })
    end

    it "passes when given valid attributes" do
      @food.should be_valid
    end

    it "fails when names are not tag formatted" do
      @food.name = "chicken fajita burrito"
      @food.should_not be_valid
      @food.errors[:name].should include("should be in 'tag' format from most generic to most specific")
    end

    it "fails when quantity does not contain a unit" do
      @food.serving_size = "5"
      @food.should_not be_valid
      @food.errors[:serving_size].should_not be_empty
    end

    it "fails when quantity is not a unit" do
      @food.serving_size = "5 garbles"
      @food.should_not be_valid
      @food.errors[:serving_size].should_not be_empty
    end

    it "fails when servings is nil" do
      @food.servings = nil
      @food.should_not be_valid
      @food.errors[:servings].should_not be_empty
    end

    it "fails when serving_size is nil" do
      @food.serving_size = nil
      @food.should_not be_valid
      @food.errors[:serving_size].should_not be_empty
    end
  end

  describe "#average_price_per_serving" do
    it "uses average price and servings to calculate" do
      food = UserFood.new(:servings => 2, :serving_size => "170 grams")
      food.stub!(:average_price).and_return(5.00)
      food.average_price_per_serving.should == 2.5
    end

    it "returns nil if average_price is nil" do
      food = UserFood.new(:servings => 2, :serving_size => "170 grams")
      food.stub!(:average_price).and_return(nil)
      food.average_price_per_serving.should be_nil
    end
  end

end
