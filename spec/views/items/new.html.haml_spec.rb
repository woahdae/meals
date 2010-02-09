require 'spec_helper'

describe "/items/new.html.haml" do
  include ItemsHelper
  
  before(:each) do
    assigns[:recipe] = @recipe = Factory(:recipe)
    assigns[:item] = @item = Factory.build(:item)
  end

  it "should render new form" do
    render "/items/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", recipe_items_path(@recipe)) do
      with_tag("input#item_name[name=?]", "item[name]")
      with_tag("input#item_amount_with_unit[name=?]", "item[amount_with_unit]")
    end
  end
end


