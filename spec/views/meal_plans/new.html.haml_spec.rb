require 'spec_helper'

describe "/meal_plans/new.html.haml" do
  include MealPlansHelper
  
  before(:each) do
    assigns[:meal_plan] = Factory.build(:meal_plan)
  end

  it "should render new form" do
    render "/meal_plans/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", meal_plans_path) do
      with_tag("input#meal_plan_name[name=?]", "meal_plan[name]")
    end
  end
end


