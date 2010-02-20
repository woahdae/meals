require 'spec_helper'

describe Receipt do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "is valid when given given valid attributes" do
    Receipt.new(@valid_attributes).should be_valid
  end
  
  describe "name" do
    before do
      @receipt = Receipt.new(:store => mock_model(Store, :name => "Trader Joes"), :created_at => Time.now)
    end
    
    it "combines store name and created at" do
      @receipt.name.should == "Trader Joes 02/20/2010"
    end
    
    it "works without a store" do
      @receipt.store = nil
      @receipt.name.should == " 02/20/2010"
    end
  end
end
