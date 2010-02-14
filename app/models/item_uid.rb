class ItemUID < ActiveRecord::Base
  has_many :items
  has_many :receipt_items
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
  
  def self.search_by_name(term)
    return [] if term.blank?
    
    ndb_data = UsdaNdb::AbbreviatedData.all(
      :select     => "ndb_no",
      :conditions => "short_description LIKE '%#{term}%'",
      :order      => "LENGTH(short_description)")
    self.all(:conditions => {:usda_ndb_id => ndb_data.collect(&:ndb_no)})
  end
end
