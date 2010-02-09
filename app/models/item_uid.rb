class ItemUID < ActiveRecord::Base
  has_many :items
  belongs_to :usda_data, :class_name => "UsdaNdb::AbbreviatedData", :foreign_key => "ndb_no"
  
  def self.default_scoping
    [{
      :create => {},
      :find   => { :include => :usda_data }
    }]
  end
end
