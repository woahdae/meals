require 'spec_helper'

describe "/stores/new.html.haml" do
  helper StoresHelper
  
  before(:each) do
    assign(:store, Factory.build(:store))
  end

  it "should render new form" do
    render :file => "/stores/new.html.haml"

    rendered.should have_selector("form", :action => stores_path, :method => 'post') do |form|
      form.should have_selector("input#store_street", :name => "store[street]")
      form.should have_selector("input#store_state", :name => "store[state]")
      form.should have_selector("input#store_city", :name => "store[city]")
      form.should have_selector("input#store_zip", :name => "store[zip]")
      form.should have_selector("input#store_name", :name => "store[name]")
    end
  end
end


