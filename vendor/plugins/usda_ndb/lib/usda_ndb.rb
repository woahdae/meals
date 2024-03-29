require 'rubygems'
require 'active_record'
require 'ruby-units'

unless defined?(Rails)
  module Rails
    def self.env
      'test'
    end
  end
end

module UsdaNdb
  def self.configurations
    @configurations ||= YAML::load(File.read("config/usda_ndb.yml"))
  end
end

require "usda_ndb/ruby_units_ext"
require "usda_ndb/abbreviated_data"
require "usda_ndb/food_description"
