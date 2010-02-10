class ItemUID < ActiveRecord::Base
  has_many :items
  belongs_to :usda_data, :class_name => "UsdaNdb::AbbreviatedData", :foreign_key => "usda_ndb_id"
  
  # def self.default_scoping
  #   [{
  #     :create => {},
  #     :find   => { :include => :usda_data }
  #   }]
  # end
  
  def name
    usda_data.try(:short_description)
  end
end
