require 'rubygems'
require 'active_record'

module UsdaNdb
  def self.configurations
    @configurations = YAML::load(File.read("config/usda_ndb.yml"))
  end
end

require "usda_ndb/abbreviated_data"