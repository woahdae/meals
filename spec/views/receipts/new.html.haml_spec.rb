require 'spec_helper'

describe "/receipts/new.html.haml" do
  helper ReceiptsHelper
  
  before(:each) do
    assign(:receipt, Factory.build(:receipt))
  end

  it "should render new form" do
    render :file => "/receipts/new.html.haml"

    rendered.should have_selector("form", :action => receipts_path, :method => "post")
  end
end


