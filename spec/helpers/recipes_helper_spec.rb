require 'spec_helper'

describe RecipesHelper do
  include RecipesHelper
  
  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(RecipesHelper)
  end
  
  describe "completion_to_color" do
    it "returns green when completion is at 100%" do
      completion_to_color(1).should == "#007f00"
    end
    
    it "moves towards yellow as completion decreases" do
      completion_to_color(0.5).should == "#7fbe00"
    end
  end
  
end
