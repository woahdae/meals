require 'spec_helper'

describe ReceiptItem do
  context "validation" do
    before(:each) do
      @receipt_item = ReceiptItem.new({
        :item_uid_id => "1",
        :name => "value for name",
        :price => "9.99",
        :qty => "1.5 lbs" })
    end

    it "passes when given given valid attributes" do
      @receipt_item.should be_valid
    end
    
    it "fails when quantity is not a unit" do
      @receipt_item.qty = "5 garbles"
      @receipt_item.should_not be_valid
      @receipt_item.errors[:qty].should_not be_empty
    end
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
