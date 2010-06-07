class Food < ActiveRecord::Base
  has_one :uid, :class_name => "ItemUID"
  belongs_to :user

  validates_format_of :name, :with => /,/, 
    :message => %(should be in 'tag' format from most generic to most specific, ex: "burrito, chicken fajita, trader joes")
  validates_presence_of :serving_size, :servings
  
  def validate
    begin
      errors.add(:serving_size, "must contain a unit (ex. #{serving_size} grams)") if serving_size.present? && serving_size.to_unit.units.blank?
    rescue => e
      if e.message.include?("Unit not recognized")
        errors.add(:serving_size, "'#{serving_size}' is not a valid unit")
      else
        raise
      end
    end
  end
  
  after_create { |food| ItemUID.create(:food => food) }
  after_update { |food| FerretItemUID.update(food.uid) }

  def dv_vitamin_a
    self[:dv_vitamin_a] || UsdaNdb::DailyValues.new('Vitamin A').percent_daily_value(vitamin_a) * 100
  end

  def dv_vitamin_c
    self[:dv_vitamin_a] || UsdaNdb::DailyValues.new('Vitamin C').percent_daily_value(vitamin_c) * 100
  end

  def dv_calcium
    self[:dv_vitamin_a] || UsdaNdb::DailyValues.new('Calcium').percent_daily_value(calcium) * 100
  end

  def dv_iron
    self[:dv_vitamin_a] || UsdaNdb::DailyValues.new('Iron').percent_daily_value(iron) * 100
  end

  def item_uid_id
    uid.id
  end
  
  # how much one package holds
  def qty
    servings * serving_size.to_unit
  end
  
  def average_price
    uid.try(:average_price, qty)
  end
  
  def average_price_per_amount
    uid.try(:average_price_per_amount, qty)
  end
  
  def average_price_per_serving
    return nil if average_price.nil?
    
    average_price(qty) / servings
  end
  
  def measure(nutrient)
    result = self.send(nutrient) if self.respond_to?(nutrient)
    result ||= uid.usda_abbreviated_data.try(:measure, nutrient, serving_size)
  end
  
  def to_param  
    "#{self.id}-#{self.name.parameterize}"  
  end
end
