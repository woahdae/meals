require 'spec_helper'

describe "/receipts/show.html.haml" do
  include ReceiptsHelper
  
  before(:each) do
    assigns[:receipt] = @receipt = Factory(:receipt)
  end

  it "should render attributes in <p>" do
    render "/receipts/show.html.haml"
  end
end

