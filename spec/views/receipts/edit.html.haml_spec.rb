require 'spec_helper'

describe "/receipts/edit.html.haml" do
  include ReceiptsHelper
  
  before(:each) do
    assigns[:receipt] = @receipt = Factory.create(:receipt, 
      :store => Factory.build(:store) )
  end

  it "should render edit form" do
    render "/receipts/edit.html.haml"

    response.should have_tag("form[action=#{receipt_path(@receipt)}][method=post]") do
    end
  end
end


