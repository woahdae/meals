require 'spec_helper'

describe "/receipts/index.html.haml" do
  helper ReceiptsHelper
  
  before(:each) do
    assign(:receipts, [ Factory(:receipt), Factory(:receipt) ])
  end

  it "should render list of receipts" do
    render :file => "/receipts/index.html.haml"
  end
end

