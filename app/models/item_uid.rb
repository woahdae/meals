class ItemUID < ActiveRecord::Base
  has_many :items
  has_many :receipt_items
  belongs_to :usda_abbreviated_data, :class_name => "UsdaNdb::AbbreviatedData", :foreign_key => "usda_ndb_id"
  belongs_to :usda_food_description, :class_name => "UsdaNdb::FoodDescription", :foreign_key => "usda_ndb_id"
  belongs_to :food, :class_name => "Food", :foreign_key => "food_id"
  
  after_save    { |item| FerretItemUID.update(item) }
  after_destroy { |item| FerretItemUID.delete(item) }
  
  # def self.default_scoping
  #   [{
  #     :create => {},
  #     :find   => { :include => :usda_food_description }
  #   }]
  # end
  
  def name
    name = food.try(:name)
    name ||= usda_food_description.try(:long_description)
  end
  
  def first_word_in_name
    return "" if name.blank?
    
    name.split(",").first.singularize
  end
  
  def measure(*args)
    result = food.try(:measure, *args) if food.respond_to?(args.first)
    result ||= usda_abbreviated_data.try(:measure, *args) if usda_abbreviated_data.respond_to?(args.first)
  end
  
  def average_price_per_base_unit
    return nil if receipt_items.empty?
    
    receipt_items.collect(&:price_per_base_unit).sum / receipt_items.size
  end
  
  def average_price_per_amount(qty)
    return nil if average_price_per_base_unit.nil?
    
    average_price_per_base_unit.convert_to("USD/#{qty.to_unit.units}")
  end
  
  def average_price(qty)
    return nil if average_price_per_base_unit.nil? || qty.blank?

    qty.to_unit.to_base * average_price_per_base_unit
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
