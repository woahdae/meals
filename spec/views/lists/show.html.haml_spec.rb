require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/lists/show.html.haml" do
  helper ListsHelper, RecipesHelper
  
  before(:each) do
    @list = Factory(:list)
    assign(:list, @list)
  end

  it "should render attributes in <p>" do
    render :file => "/lists/show.html.haml"
  end
end

