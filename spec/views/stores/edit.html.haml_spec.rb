require 'spec_helper'

describe "/stores/edit.html.haml" do
  helper StoresHelper
  
  before(:each) do
    @store = Factory(:store)
    assign(:store, @store)
  end

  it "should render edit form" do
    render :file => "/stores/edit.html.haml"

    rendered.should have_selector("form", :action => store_path(@store), :method => "post") do |form|
      form.should have_selector("input#store_street", :name => "store[street]")
      form.should have_selector("input#store_state",  :name => "store[state]")
      form.should have_selector("input#store_city",   :name => "store[city]")
      form.should have_selector("input#store_zip",    :name => "store[zip]")
      form.should have_selector("input#store_name",   :name => "store[name]")
    end
  end
end


