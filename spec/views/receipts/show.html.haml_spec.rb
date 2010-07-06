require 'spec_helper'

describe "/receipts/show.html.haml" do
  helper ReceiptsHelper
  
  before(:each) do
    @receipt = Factory(:receipt)
    assign(:receipt, @receipt)
  end

  it "should render attributes in <p>" do
    render :file => "/receipts/show.html.haml"
  end
end

