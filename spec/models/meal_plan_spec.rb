require 'spec_helper'

describe MealPlan do
  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    MealPlan.new(@valid_attributes).should be_valid
  end
end
