RSpec::Matchers.define :eq_unit do |expected|
  match do |actual|
    actual.should be_close(expected.to_unit, 0.01)
  end
end
