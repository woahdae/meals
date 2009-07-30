require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/items/show.html.haml" do
  include ItemsHelper
  
  before(:each) do
    assigns[:item] = @item = Factory(:item)
  end

  it "should render attributes in <p>" do
    render "/items/show.html.haml"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ amount/)
    response.should have_text(/9\.99/)
    response.should have_text(/1\.5/)
    response.should have_text(/1/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
  end
end

