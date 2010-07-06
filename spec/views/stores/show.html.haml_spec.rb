require 'spec_helper'

describe "/stores/show.html.haml" do
  helper StoresHelper
  
  before(:each) do
    @store = Factory(:store)
    assign(:store, @store)
  end

  it "should render attributes in <p>" do
    render :file => "/stores/show.html.haml"
    rendered.should contain(/value\ for\ street/)
    rendered.should contain(/value\ for\ state/)
    rendered.should contain(/value\ for\ city/)
    rendered.should contain(/value\ for\ zip/)
    rendered.should contain(/value\ for\ name/)
  end
end

