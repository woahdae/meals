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
end
