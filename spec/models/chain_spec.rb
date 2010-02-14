require 'spec_helper'

describe Chain do
  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end

  it "is valid when given given valid attributes" do
    Chain.new(@valid_attributes).should be_valid
  end
end
