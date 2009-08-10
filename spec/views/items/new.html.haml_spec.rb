require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

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
      with_tag("input#item_bulk_price[name=?]", "item[bulk_price]")
      with_tag("input#item_bulk_qty_with_unit[name=?]", "item[bulk_qty_with_unit]")
      with_tag("input#item_calories[name=?]", "item[calories]")
      with_tag("input#item_fat[name=?]", "item[fat]")
      with_tag("input#item_carbs[name=?]", "item[carbs]")
      with_tag("input#item_protein[name=?]", "item[protein]")
    end
  end
end


