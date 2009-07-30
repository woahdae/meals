require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/recipes/show.html.haml" do
  include RecipesHelper
  
  before(:each) do
    assigns[:recipe] = @recipe = Factory(:recipe)
  end

  it "should render attributes in <p>" do
    render "/recipes/show.html.haml"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ directions/)
  end
end

