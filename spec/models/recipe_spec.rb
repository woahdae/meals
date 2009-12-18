require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Recipe do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :prep_time => "1.5",
      :cook_time => "1.5",
      :servings => "1",
      :directions => "value for directions"
    }
  end

  it "should create a new instance given valid attributes" do
    Recipe.create!(@valid_attributes)
  end
  
  it "should calculate cost" do
    recipe = Factory.build(:recipe, :items => [Factory.build(:item), Factory.build(:item)])
    
    # 2 items at 9.99 per 1.5 lbs (6.66/lb), each item requiring 5 lbs
    recipe.cost.round(2).to_s.should == "9.08"
  end
  
  it "should calculate cost when using volume-based units" do
    recipe = Factory.build(:recipe, :items => [Factory.build(:item_using_volume_units), Factory.build(:item_using_volume_units)])
    
    # 2 items at 9.99/gal, each item requiring 5 cups
    recipe.cost.round(2).to_s.should == "6.24"
  end
  
  it "should calculate bulk cost" do
    recipe = Factory.build(:recipe, :items => [Factory.build(:item), Factory.build(:item)])
    recipe.bulk_cost.to_s.should == "19.98"
  end
  
  it "should calculate servings from bulk quantities" do
    recipe = Factory.build(:recipe, :items => [Factory.build(:item), Factory.build(:item)])
    
    recipe.servings_from_bulk.should == 2
  end

  it "servings_from_bulk should return nil if an item is missing bulk or amount data" do
    recipe = Factory.build(:recipe, :items => [Factory.build(:item), Factory.build(:item, :bulk_qty => nil, :bulk_qty_unit => nil)])
    
    recipe.servings_from_bulk.should be_nil
  end
  
  it "price_per_serving should return nil if incompatable units" do
    recipe = Factory.build(:recipe, :items => [
      Factory.build(:item, :bulk_qty_unit => "pounds"), 
      Factory.build(:item, :bulk_qty_unit => "tablespoons")
    ])
    
    recipe.price_per_serving.should be_nil
  end
end
