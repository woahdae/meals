require 'spec_helper'

describe "/receipts/edit.html.haml" do
  helper ReceiptsHelper
  
  before(:each) do
    @receipt = Factory.create(:receipt, 
      :store => Factory.build(:store) )
    assign(:receipt, @receipt)
  end

  it "should render edit form" do
    render :file => "/receipts/edit.html.haml"
    rendered.should have_selector("form", :action => receipt_path(@receipt), :method => "post")
  end
end


