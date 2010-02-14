require 'spec_helper'

describe "/stores/new.html.haml" do
  include StoresHelper
  
  before(:each) do
    assigns[:store] = Factory.build(:store)
    assigns[:chains] = [Factory.build(:chain)]
  end

  it "should render new form" do
    render "/stores/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", stores_path) do
      with_tag("input#store_street[name=?]", "store[street]")
      with_tag("input#store_state[name=?]", "store[state]")
      with_tag("input#store_city[name=?]", "store[city]")
      with_tag("input#store_zip[name=?]", "store[zip]")
      with_tag("input#store_name[name=?]", "store[name]")
    end
  end
end


