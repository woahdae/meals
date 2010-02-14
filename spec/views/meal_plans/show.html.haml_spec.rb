require 'spec_helper'

describe "/meal_plans/show.html.haml" do
  include MealPlansHelper
  
  before(:each) do
    assigns[:meal_plan] = @meal_plan = Factory(:meal_plan)
  end

  it "should render attributes in <p>" do
    render "/meal_plans/show.html.haml"
    response.should have_text(/value\ for\ name/)
  end
end

