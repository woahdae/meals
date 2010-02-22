class Recipe < ActiveRecord::Base
  has_many :items, :dependent => :destroy
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
    price = self.items.inject(0.to_unit('dollar')) {|price, item| price += (item.average_price || 0)}
    
    return price.scalar.to_f
  end
  
  def average_price_per_serving
    (self.average_price / self.servings).to_f
  end

  def measure(nutrient)
    items.inject(0) {|value, item| value += ((item.measure(nutrient) || 0) / servings)}
  end

  def to_param  
    "#{self.id}-#{self.name.parameterize}"  
  end
end
