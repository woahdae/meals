require 'spec_helper'

describe "/stores/show.html.haml" do
  include StoresHelper
  
  before(:each) do
    assigns[:store] = @store = Factory(:store)
  end

  it "should render attributes in <p>" do
    render "/stores/show.html.haml"
    response.should have_text(/value\ for\ street/)
    response.should have_text(/value\ for\ state/)
    response.should have_text(/value\ for\ city/)
    response.should have_text(/value\ for\ zip/)
    response.should have_text(/value\ for\ name/)
  end
end

