class ItemUID < ActiveRecord::Base
  extend Gaston::Base
  
  has_many :items
  has_many :receipt_items
  belongs_to :usda_data, :class_name => "UsdaNdb::AbbreviatedData", :foreign_key => "usda_ndb_id"
  
  define_index do |index|
    index.fields :name, :first_word_in_name
    index.finder_options :include => :usda_data
  end
  
  after_save    { |item| Gaston::Index.update(item) }
  after_destroy { |item| Gaston::Index.delete(item) }
  
  # def self.default_scoping
  #   [{
  #     :create => {},
  #     :find   => { :include => :usda_data }
  #   }]
  # end
  
  def name
    usda_data.try(:short_description)
  end
  
  def first_word_in_name
    name.split(",").first.singularize
  end

  def self.search_by_name(term, options = {})
    return [] if term.blank?
    Gaston::Index.search(self.name, FerretItemUID.make_query(term), options)
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
