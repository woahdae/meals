require File.dirname(__FILE__) + '/../test_helper'
require 'units/currency'

class CurrencyTest < Test::Unit::TestCase
  def test_euro_to_dollar
    assert_equal Hash.new, Numeric.currency_rates

    assert_in_delta 1.5, 1.euro.usd, 0.5
    assert Numeric.currency_rates[:euro_to_euro] == 1.0
    assert_equal 2, Numeric.currency_rates.size
  end
end