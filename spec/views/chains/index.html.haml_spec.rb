require 'spec_helper'

describe "/chains/index.html.haml" do
  include ChainsHelper
  
  before(:each) do
    assigns[:chains] = [ Factory(:chain, :name => "Trader Joes"), Factory(:chain, :name => "Safeway") ]
  end

  it "should render list of chains" do
    render "/chains/index.html.haml"
    response.should have_tag("tr>td", "Trader Joes", 1)
    response.should have_tag("tr>td", "Safeway",     1)
  end
end

