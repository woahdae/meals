require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/items/edit.html.haml" do
  include ItemsHelper
  
  before(:each) do
    assigns[:item] = @item = Factory(:item)
    assigns[:recipe] = @recipe = Factory(:recipe)
  end

  it "should render edit form" do
    render "/items/edit.html.haml"
    
    response.should have_tag("form[action=#{recipe_item_path(@recipe, @item)}][method=post]") do
      with_tag('input#item_name[name=?]', "item[name]")
      with_tag('input#item_amount_with_unit[name=?]', "item[amount_with_unit]")
      with_tag('input#item_bulk_price[name=?]', "item[bulk_price]")
      with_tag('input#item_bulk_qty_with_unit[name=?]', "item[bulk_qty_with_unit]")
      with_tag('input#item_calories[name=?]', "item[calories]")
      with_tag('input#item_fat[name=?]', "item[fat]")
      with_tag('input#item_carbs[name=?]', "item[carbs]")
      with_tag('input#item_protein[name=?]', "item[protein]")
    end
  end
end


