require 'spec_helper'

describe Item do
  context "validation" do
    before(:each) do
      @item = Item.new({
        :name => "value for name",
        :qty => "5 pounds",
        :recipe_id => "1" })
    end

    it "passes when given given valid attributes" do
      @item.should be_valid
    end

    it "fails when quantity does not contain a unit" do
      @item.qty = "5"
      @item.should_not be_valid
      @item.errors[:qty].should_not be_empty
    end
    
    it "fails when quantity is not a unit" do
      @item.qty = "5 garbles"
      @item.should_not be_valid
      @item.errors[:qty].should_not be_empty
    end
  end
  
  context "calculates" do
    before do
      @receipt_item1 = Factory.build(:receipt_item, :qty => "2 lbs", :price => "5.00")
      @receipt_item2 = Factory.build(:receipt_item, :qty => "16 oz", :price => "10.00")
      @food = Factory.build(:usda_ndb_food,
        :receipt_items => [@receipt_item1, @receipt_item2])
      @item = Factory.build(:item, :qty => "16 oz", :food => @food)
    end
    
    it "average_price" do
      # (13.78 $/kg) * 16 oz (aka 0.45359 kg) => 6.25
      
      @item.average_price.scalar.round(2).should == 6.25
      @item.average_price.units.should == "USD"
    end
  end
  
  it "passes on nutrition values to the uid along with its qty" do
    item = Item.new(:qty => "5 pounds")
    food = mock('food')
    food.should_receive(:measure).with(:kcal, '5 pounds').and_return(250)
    item.stub!(:food).and_return(food)
    item.measure(:kcal) == 250
  end
end
