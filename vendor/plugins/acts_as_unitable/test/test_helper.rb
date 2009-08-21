require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_support/test_case'

require 'activerecord'
require 'ruby-units'
require File.dirname(__FILE__) + '/../lib/acts_as_unitable'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database  => ":memory:"
)

ActiveRecord::Schema.define do
  create_table "items", :force => true do |t|
    t.float  :quantity
    t.string :quantity_unit
  end
end

class Item < ActiveRecord::Base
  acts_as_unitable :quantity
end
