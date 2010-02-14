require 'spec_helper'

describe "/receipts/index.html.haml" do
  include ReceiptsHelper
  
  before(:each) do
    assigns[:receipts] = [ Factory(:receipt), Factory(:receipt) ]
  end

  it "should render list of receipts" do
    render "/receipts/index.html.haml"
  end
end

