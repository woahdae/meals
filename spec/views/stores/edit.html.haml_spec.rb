require 'spec_helper'

describe "/stores/edit.html.haml" do
  include StoresHelper
  
  before(:each) do
    assigns[:store] = @store = Factory(:store)
  end

  it "should render edit form" do
    render "/stores/edit.html.haml"
    
    response.should have_tag("form[action=#{store_path(@store)}][method=post]") do
      with_tag('input#store_street[name=?]', "store[street]")
      with_tag('input#store_state[name=?]', "store[state]")
      with_tag('input#store_city[name=?]', "store[city]")
      with_tag('input#store_zip[name=?]', "store[zip]")
      with_tag('input#store_name[name=?]', "store[name]")
    end
  end
end


