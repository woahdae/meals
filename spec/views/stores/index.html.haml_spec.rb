require 'spec_helper'

describe "/stores/index.html.haml" do
  helper StoresHelper
  
  before(:each) do
    assign(:stores, [ Factory(:store), Factory(:store) ])
  end

  it "should render list of stores" do
    render :file => "/stores/index.html.haml"
    rendered.should have_selector("td") do |td|
      td.should contain("value for street")
      td.should contain("value for state")
      td.should contain("value for city")
      td.should contain("value for zip")
      td.should contain("value for name")
    end
  end
end

