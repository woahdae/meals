class Recipe < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  has_many :foods, :through => :items
  has_many :photos, :class_name => "RecipePhoto", :foreign_key => "photoable_id", :dependent => :destroy
  belongs_to :user
  accepts_nested_attributes_for :items
  accepts_nested_attributes_for :photos
  
  validates_presence_of :name
  validates_presence_of :user_id
  validates_numericality_of :servings, :greater_than => 0
  
  before_validation { |record| record.photos.delete_if {|photo| photo.filename.nil?} }
  before_validation { |record| record.items.delete_if {|item| item.name.blank?} }
  
  def main_photo
    photos.first
  end
  
  def alternate_photos
    (photos - [main_photo])
  end
  
  def average_price
    Measurement.new(0.to_unit("dollar")).tap do |measure|
      items.each do |item|
        if item.average_price.nil?
          measure.missing << item
        else
          measure.items["#{item.name} (#{(item.qty.to_unit).round(2)})"] = item.average_price.round(2)
          measure.value += item.average_price
        end
      end
    end
  end
  
  def average_price_per_serving
    Measurement.new(0.to_unit("dollar")).tap do |measure|
      items.each do |item|
        if item.average_price.nil?
          measure.missing << item
        else
          measure.items["#{item.name} (#{(item.qty.to_unit / servings).round(2)})"] = (item.average_price / servings).round(2)
          measure.value += item.average_price / servings
        end
      end
    end
  end

  def measure(nutrient)
    Measurement.new(0).tap do |measure|
      items.each do |item|
        if item.measure(nutrient).nil?
          measure.missing << item
        else
          measure.items["#{item.name} (#{(item.qty.to_unit / servings).round(2)})"] = (item.measure(nutrient) / servings).round
          measure.value += (item.measure(nutrient) / servings)
        end
      end
    end
  end

  def daily_value(nutrient)
    items.inject(0) do |value, item|
      return nil if item.daily_value(nutrient).nil?
      
      value += (item.daily_value(nutrient) / servings)
    end
  end

  def serving_size
    (items.to_a.sum(&:qty))/servings rescue nil
  end
  
  def missing
    @missing ||= begin
      result = items.inject({}) do |result, item|
        if item.food_id.nil?
          result['food'] ||= []
          result['food'] << item
        
          next result
        end
      
        if item.food.try(:receipt_items).blank?
          result['receipts'] ||= []
          result['receipts'] << item 
        end
      
        result
      end
    
      result['photos'] = true if photos.blank?
      
      result
    end
  end
  
  def completion
    missing_photo_penalty = items.size
    actual = missing['food'].try(:size).to_i + missing['receipts'].try(:size).to_i + (missing['photos'] ? missing_photo_penalty : 0)
    available = items.size * 2 + missing_photo_penalty
    
    ((available - actual) / available).to_f
  end
  
  def to_param  
    "#{self.id}-#{self.name.parameterize}"  
  end
end
