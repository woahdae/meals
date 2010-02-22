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
  
  it "sums cost from its items" do
    @receipt_item1 = Factory.build(:receipt_item, :qty => "2 lbs", :price => "5.00", :item_uid_id => 5000)
    @receipt_item2 = Factory.build(:receipt_item, :qty => "1 lbs", :price => "10.00", :item_uid_id => 6000)
    
    @item1 = Factory.build(:item, :qty => "8 oz", :item_uid_id => 5000)
    @item2 = Factory.build(:item, :qty => "16 oz", :item_uid_id => 6000)
    
    @item1.stub!(:receipt_items).and_return([@receipt_item1])
    @item2.stub!(:receipt_items).and_return([@receipt_item2])
    
    recipe = Factory.build(:recipe, :items => [@item1, @item2])

    recipe.average_price.round(2).to_s.should == "11.25"
  end
  
  it "sums nutrition data from its items" do
    item1 = mock_model(Item, :measure => 100)
    item2 = mock_model(Item, :measure => 100)
    recipe = Recipe.new(:items => [item1, item2])
    recipe.measure(:kcal).should == 200
  end
end
