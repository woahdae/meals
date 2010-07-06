require 'spec_helper'

describe "/recipes/show.html.haml" do
  helper RecipesHelper

  before(:each) do
    @recipe = Factory(:recipe, :items => [Factory(:item)])
    @items  = [@recipe.items]
    assign(:recipe, @recipe)
    assign(:items, @items)
    view.stub(:current_user_owns? => false)
  end

  it "should render attributes in <p>" do
    render :file => "/recipes/show.html.haml"
    rendered.should contain(/1\.5/)
    rendered.should contain(/1\.5/)
    rendered.should contain(/1/)
    rendered.should contain(/value\ for\ directions/)
  end
end

