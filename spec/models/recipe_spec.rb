require 'spec_helper'

describe Recipe do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :prep_time => "1.5",
      :cook_time => "1.5",
      :servings => "1",
      :directions => "value for directions",
      :user_id => 1
    }
  end

  it "is valid when given given valid attributes" do
    Recipe.new(@valid_attributes).should be_valid
  end
  
  it "should calculate cost" do
    @receipt_item1 = Factory.build(:receipt_item, :qty_with_unit => "2 lbs", :price => "5.00", :item_uid_id => 5000)
    @receipt_item2 = Factory.build(:receipt_item, :qty_with_unit => "1 lbs", :price => "10.00", :item_uid_id => 6000)
    
    @item1 = Factory.build(:item, :amount_with_unit => "8 oz", :item_uid_id => 5000)
    @item2 = Factory.build(:item, :amount_with_unit => "16 oz", :item_uid_id => 6000)
    
    @item1.stub!(:receipt_items).and_return([@receipt_item1])
    @item2.stub!(:receipt_items).and_return([@receipt_item2])
    
    recipe = Factory.build(:recipe, :items => [@item1, @item2])

    recipe.average_price.round(2).to_s.should == "11.25"
  end
end
