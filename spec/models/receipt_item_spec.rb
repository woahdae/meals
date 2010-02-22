require 'spec_helper'

describe ReceiptItem do
  before(:each) do
    @valid_attributes = {
      :item_uid_id => "1",
      :name => "value for name",
      :price => "9.99",
      :qty => "1.5",
      :qty_unit => "5 lbs"
    }
  end

  it "is valid when given given valid attributes" do
    ReceiptItem.new(@valid_attributes).should be_valid
  end
  
  context "calculates" do
    before do
      @receipt_item = Factory.build(:receipt_item, :price => 3.00)
      @receipt_item.qty = "5 lbs"
    end
    
    it "dollars per base unit" do
      @receipt_item.price_per_base_unit.base_scalar.round(2).should == 1.32
      @receipt_item.price_per_base_unit.units.should == "USD/kg"
    end
  end
end
