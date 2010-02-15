require "spec_helper"

module Gaston
  describe SearchResults do
    it "passes most methods through to the array of resultant objects" do
      arr = mock("array")
      arr.should_receive(:fake_method).with(1, "arg")
      SearchResults.new(100, arr).fake_method(1, "arg")
    end

    it "holds the total matched count" do
      arr = mock("array")
      results = SearchResults.new(100, arr)
      results.count.should == 100
    end
  end
end
