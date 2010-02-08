class ItemUID < ActiveRecord::Base
  has_many :items
  has_one :usda_data, :class_name => "UsdaNdb::AbbreviatedData", :foreign_key => "ndb_no"
end
