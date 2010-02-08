require 'spec_helper'

describe ItemUID do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    ItemUID.new(@valid_attributes).should be_valid
  end
end
