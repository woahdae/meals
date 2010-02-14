require 'spec_helper'

describe Receipt do
  before(:each) do
    @valid_attributes = {
      :user_id => "1",
      :store_id => "1"
    }
  end

  it "is valid when given given valid attributes" do
    Receipt.new(@valid_attributes).should be_valid
  end
end
