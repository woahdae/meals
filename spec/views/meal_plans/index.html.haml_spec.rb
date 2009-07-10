require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/meal_plans/index.html.haml" do
  include MealPlansHelper
  
  before(:each) do
    assigns[:meal_plans] = [ Factory(:meal_plan), Factory(:meal_plan) ]
  end

  it "should render list of meal_plans" do
    render "/meal_plans/index.html.haml"
    response.should have_tag("tr>td", "value for name", 2)
  end
end

