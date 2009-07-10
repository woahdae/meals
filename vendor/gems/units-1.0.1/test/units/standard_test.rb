require File.dirname(__FILE__) + '/../test_helper'

class StandardTest < Test::Unit::TestCase
	def test_weight
	   assert_equal 64.0, 4.pounds.to_ozs
	   assert_equal :ounces, (4.pounds.to_ozs).units
	   assert_equal :weight, (4.pounds.to_ozs).kind
	end

	def test_volume
	   assert_equal 4.0, 1.cup.to_quarts
	   assert_equal :quarts, (1.cup.to_quarts).units
	   assert_equal :volume, (1.cup.to_quarts).kind
	end	

	def test_time
	   assert_equal 60.0, 1.minute.to_seconds
	   assert_equal :seconds, (1.minute.to_seconds).unit
	   assert_equal :time, (1.minute.to_seconds).kind
	end	

	def test_size
	   assert_equal 1024.0, 1.mb.to_kb
	   assert_equal :kilobytes, (1.mb.to_kb).units
	   assert_equal :size, (1.mb.to_kb).kind
	end	

	def test_length
	   assert_equal 2.5400000025908, 1.inch.to_cm
	   assert_equal :centimeters, (1.inch.to_cm).units
	   assert_equal :length, (1.inch.to_cm).kind
	end	
end