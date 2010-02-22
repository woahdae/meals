require 'spec_helper'

# I added tablespoons as tbsp to ruby-units,
# but just in case it gets reverted I should write a test

describe Unit do
  it "recognizes tablespoons as tbsp" do
    lambda {"1 tbsp".to_unit}.should_not raise_error
  end
end