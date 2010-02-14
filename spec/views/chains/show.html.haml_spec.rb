require 'spec_helper'

describe "/chains/show.html.haml" do
  include ChainsHelper
  
  before(:each) do
    assigns[:chain] = @chain = Factory(:chain)
  end

  it "should render attributes in <p>" do
    render "/chains/show.html.haml"
    response.should have_text(/value\ for\ name/)
  end
end

