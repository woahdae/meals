require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/items/edit.html.haml" do
  include ItemsHelper
  
  before(:each) do
    assigns[:item] = @item = Factory(:item)
    assigns[:recipe] = @recipe = Factory(:recipe)
    assigns[:item_uids] = Factory.build(:item_uid)
  end

  it "should render edit form" do
    render "/items/edit.html.haml"
    
    response.should have_tag("form[action=#{recipe_item_path(@recipe, @item)}][method=post]") do
      with_tag('input#item_name[name=?]', "item[name]")
      with_tag('input#item_amount_with_unit[name=?]', "item[amount_with_unit]")
      with_tag('select#item_item_uid_id[name=?]', "item[item_uid_id]")
    end
  end
end


