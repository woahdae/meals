require 'spec_helper'

describe "/receipts/new.html.haml" do
  include ReceiptsHelper
  
  before(:each) do
    assigns[:receipt] = Factory.build(:receipt)
  end

  it "should render new form" do
    render "/receipts/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", receipts_path) do
    end
  end
end


