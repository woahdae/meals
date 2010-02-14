require 'spec_helper'

describe Store do
  before(:each) do
    @valid_attributes = {
      :street => "value for street",
      :state => "value for state",
      :city => "value for city",
      :zip => "value for zip",
      :name => "value for name",
      :chain_id => "1"
    }
  end

  it "is valid when given given valid attributes" do
    Store.new(@valid_attributes).should be_valid
  end
end
