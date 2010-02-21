class ItemUID < ActiveRecord::Base
  has_many :items
  has_many :receipt_items
  belongs_to :usda_abbreviated_data, :class_name => "UsdaNdb::AbbreviatedData", :foreign_key => "usda_ndb_id"
  belongs_to :usda_food_description, :class_name => "UsdaNdb::FoodDescription", :foreign_key => "usda_ndb_id"
  
  after_save    { |item| FerretItemUID.update(item) }
  after_destroy { |item| FerretItemUID.delete(item) }
  
  # def self.default_scoping
  #   [{
  #     :create => {},
  #     :find   => { :include => :usda_food_description }
  #   }]
  # end
  
  def name
    usda_food_description.try(:long_description)
  end
  
  def first_word_in_name
    name.split(",").first.singularize
  end

  # ferret-less search by name, might be nice to keep this available
  def self.fallback_search_by_name(term)
    return [] if term.blank?
    
    ndb_data = UsdaNdb::AbbreviatedData.all(
      :select     => "ndb_no",
      :conditions => "short_description LIKE '%#{term}%'",
      :order      => "LENGTH(short_description)")
    self.all(:conditions => {:usda_ndb_id => ndb_data.collect(&:ndb_no)})
  end
end
