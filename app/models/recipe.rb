class Recipe < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  has_many :photos, :class_name => "RecipePhoto", :foreign_key => "photoable_id", :dependent => :destroy
  belongs_to :user
  accepts_nested_attributes_for :items
  accepts_nested_attributes_for :photos
  
  validates_presence_of :name
  validates_numericality_of :user_id
  validates_numericality_of :servings, :greater_than => 0
  
  before_validation { |record| record.photos.delete_if {|photo| photo.filename.nil?} }
  before_validation { |record| record.items.delete_if {|item| item.name.blank?} }
  
  def main_photo
    photos.first
  end
  
  def alternate_photos
    (photos - [main_photo])
  end
  
  def cost
    price = self.items.inject(0.to_unit('dollar')) {|price, item| price += item.cost}
    
    return price.scalar.to_f
    
  rescue => e
    if e.message.match("Incompatible Units")
      return nil
    else
      raise e
    end
  end
  
  def price_per_serving
    return nil unless self.cost && self.servings
    
    (self.cost / self.servings).to_f
    
  rescue => e
    if e.message.match("Incompatible Units")
      return nil
    else
      raise e
    end
  end

  def bulk_cost
    self.items.inject(0.0) {|sum, item| sum += item.bulk_price.to_f}.round(2)
  end
  
  # finds the maximum amount you could make using up all of the bulk quantities.
  def servings_from_bulk
    self.items.inject(999999) do |floor, item|
      return nil unless item.bulk_qty_with_unit && item.amount_with_unit
      
      floor_contender = item.bulk_qty_with_unit.to_base / item.amount_with_unit.to_base
      [floor, floor_contender.scalar].min.floor
    end
    
  rescue => e
    if e.message.match("Incompatible Units")
      return nil
    else
      raise e
    end
  end
  
  def to_param  
    "#{self.id}-#{self.name.parameterize}"  
  end
end
