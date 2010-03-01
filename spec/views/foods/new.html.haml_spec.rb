require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/foods/new.html.haml" do
  include FoodsHelper
  
  before(:each) do
    assigns[:food] = Factory.build(:food)
  end

  it "should render new form" do
    render "/foods/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", foods_path) do
      with_tag("input#food_name[name=?]", "food[name]")
      with_tag("input#food_kcal[name=?]", "food[kcal]")
      with_tag("input#food_fat[name=?]", "food[fat]")
      with_tag("input#food_saturated_fat[name=?]", "food[saturated_fat]")
      with_tag("input#food_monounsaturated_fat[name=?]", "food[monounsaturated_fat]")
      with_tag("input#food_polyunsaturated_fat[name=?]", "food[polyunsaturated_fat]")
      with_tag("input#food_cholesterol[name=?]", "food[cholesterol]")
      with_tag("input#food_carbs[name=?]", "food[carbs]")
      with_tag("input#food_protein[name=?]", "food[protein]")
      with_tag("input#food_sugar[name=?]", "food[sugar]")
      with_tag("input#food_fiber[name=?]", "food[fiber]")
    end
  end
end


