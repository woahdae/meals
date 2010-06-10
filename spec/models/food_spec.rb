require 'spec_helper'

describe Food do
  context "nutrient attributes" do
    let(:attribute) {Food::NUTRIENT_ATTRIBUTES.keys.first}
    it "overwrite the default readers to instantiate Nutrient objects" do
      subject.send(attribute).class.should == Nutrient
    end
  
    it "overwrite the default writers to filter through Nutrient objects" do
      subject.send("#{attribute}=", 3000)
      subject.send(attribute).value.should == 3000
    end
    
    it "adds a reader for attribute_daily_value" do
      # I'm tired...
      subject.send("#{attribute}_daily_value").should == 0
    end
    
    it "adds an attribute_daily_value= writer" do
      subject.send("#{attribute}_daily_value=", 100.0)
      subject.send("#{attribute}_daily_value").should be_close(100.0, 0.01)
    end
  end
end
