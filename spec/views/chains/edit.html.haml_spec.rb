require 'spec_helper'

describe "/chains/edit.html.haml" do
  include ChainsHelper
  
  before(:each) do
    assigns[:chain] = @chain = Factory(:chain)
  end

  it "should render edit form" do
    render "/chains/edit.html.haml"
    
    response.should have_tag("form[action=#{chain_path(@chain)}][method=post]") do
      with_tag('input#chain_name[name=?]', "chain[name]")
    end
  end
end


