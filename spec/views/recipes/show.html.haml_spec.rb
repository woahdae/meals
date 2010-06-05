require 'spec_helper'

describe "/recipes/show.html.haml" do
  include RecipesHelper
  
  before(:each) do
    assigns[:recipe] = @recipe = Factory(:recipe, :items => [Factory(:item)])
    assigns[:items]  = @items  = [@recipe.items]
  end

  it "should render attributes in <p>" do
    render "/recipes/show.html.haml"
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ directions/)
  end
end

