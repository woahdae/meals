require 'spec_helper'

describe "/chains/new.html.haml" do
  include ChainsHelper
  
  before(:each) do
    assigns[:chain] = Factory.build(:chain)
  end

  it "should render new form" do
    render "/chains/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", chains_path) do
      with_tag("input#chain_name[name=?]", "chain[name]")
    end
  end
end


