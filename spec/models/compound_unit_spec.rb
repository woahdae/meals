require 'spec_helper'

describe CompoundUnit do
  let(:one) {CompoundUnit.new(
    :numerator => "10 USD",
    :denominator => "2 oz")}
  let(:two) {CompoundUnit.new(
    :numerator => "20 USD",
    :denominator => "28.3495231 grams")}

  it "can be summed in an array" do
    [one, two].sum.unit.should eq_unit("25 USD/oz")
  end

  describe "#+" do
    it "adds two compatible compound units together" do
      (one + two).unit.should eq_unit("25 USD/oz")
    end
  end

  describe "#convert_to" do
    it "converts a compound unit to have the same denominator as the other" do
      two.convert_to(one).unit.should eq_unit("20 USD/oz")
    end
  end
end