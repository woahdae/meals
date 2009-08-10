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
    recipe.cost.to_s.should == "66.6"
  end
end
