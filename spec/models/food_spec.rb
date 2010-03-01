require 'spec_helper'

describe Food do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :kcal => "1.5",
      :fat => "1.5",
      :saturated_fat => "1.5",
      :monounsaturated_fat => "1.5",
      :polyunsaturated_fat => "1.5",
      :cholesterol => "1.5",
      :carbs => "1.5",
      :protein => "1.5",
      :sugar => "1.5",
      :fiber => "1.5"
    }
  end

  it "should create a new instance given valid attributes" do
    Food.create!(@valid_attributes)
  end
end
