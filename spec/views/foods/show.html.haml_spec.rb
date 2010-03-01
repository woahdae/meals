require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/foods/show.html.haml" do
  include FoodsHelper
  
  before(:each) do
    assigns[:food] = @food = Factory(:food)
  end

  it "should render attributes in <p>" do
    render "/foods/show.html.haml"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
  end
end

