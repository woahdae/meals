require 'rubygems'
require 'active_record'

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

require "usda_ndb/abbreviated_data"