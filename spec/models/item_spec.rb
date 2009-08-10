require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :amount => "5",
      :amount_unit => "pounds",
      :bulk_price => "9.99",
      :bulk_qty => "1.5",
      :bulk_qty_unit => "pounds",
      :calories => "1",
      :fat => "1.5",
      :carbs => "1.5",
      :protein => "1.5",
      :recipe_id => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    Item.create!(@valid_attributes)
  end
end
