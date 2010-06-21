require 'spec_helper'

describe ReceiptItem do
  context "validation" do
    before(:each) do
      @receipt_item = ReceiptItem.new({
        :name => "value for name",
        :price => "9.99",
        :qty => "1.5 lbs" })
    end

    it "passes when given given valid attributes" do
      @receipt_item.should be_valid
    end
    
    it "fails when quantity does not contain a unit" do
      @receipt_item.qty = "5"
      @receipt_item.should_not be_valid
      @receipt_item.errors[:qty].should_not be_empty
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
    
    it "unit price" do
      @receipt_item.unit_price.unit.should eq_unit("0.6 USD/lbs")
    end
  end
end
