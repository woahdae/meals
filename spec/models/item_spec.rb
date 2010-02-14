require 'spec_helper'

describe Item do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :amount => "5",
      :amount_unit => "pounds",
      :recipe_id => "1"
    }
  end

  it "is valid when given given valid attributes" do
    Item.new(@valid_attributes).should be_valid
  end
  
  context "calculates" do
    before do
      @receipt_item1 = Factory.build(:receipt_item, :qty_with_unit => "2 lbs", :price => "5.00", :item_uid_id => 5000)
      @receipt_item2 = Factory.build(:receipt_item, :qty_with_unit => "16 oz", :price => "10.00", :item_uid_id => 5000)
      @item = Factory.build(:item, :amount_with_unit => "16 oz", :item_uid_id => 5000)
      
      @item.stub!(:receipt_items).and_return([@receipt_item1, @receipt_item2])
    end
    
    it "average_price_per_base_unit" do
      # $5.00 / 2 lbs => 5.51 $/kg
      # $10.00 / 16 oz => 22.04 $/kg
      # 5.51 + 22.04 / 2 => 13.78 $/kg
      
      @item.average_price_per_base_unit.scalar.round(2).should == 13.78
      @item.average_price_per_base_unit.units.should == "USD/kg"
    end
    
    it "average_price" do
      # (13.78 $/kg) * 16 oz (aka 0.45359 kg) => 6.25
      
      @item.average_price.scalar.round(2).should == 6.25
      @item.average_price.units.should == "USD"
    end
    
    it "average_price_per_amount" do
      # (13.78 $/kg) * 0.45359 kg/lb * 1/16 lbs/oz => 0.39 $/oz
      
      @item.average_price_per_amount.scalar.round(2).should == 0.39
      @item.average_price_per_amount.units.should == "USD/oz"
    end
  end
  
end
