require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/meal_plans/edit.html.haml" do
  include MealPlansHelper
  
  before(:each) do
    assigns[:meal_plan] = @meal_plan = Factory(:meal_plan)
  end

  it "should render edit form" do
    render "/meal_plans/edit.html.haml"
    
    response.should have_tag("form[action=#{meal_plan_path(@meal_plan)}][method=post]") do
      with_tag('input#meal_plan_name[name=?]', "meal_plan[name]")
    end
  end
end


