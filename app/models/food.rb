class Food < ActiveRecord::Base
  has_one :uid, :class_name => "ItemUID"
  has_many :receipt_items
  belongs_to :user
  belongs_to :usda_abbreviated_data, :class_name => "UsdaNdb::AbbreviatedData", :foreign_key => "usda_ndb_id"
  belongs_to :usda_food_description, :class_name => "UsdaNdb::FoodDescription", :foreign_key => "usda_ndb_id"

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

  after_save    { |food| FerretFood.update(food) }
  after_destroy { |food| FerretFood.delete(food) }

  after_create { |food| ItemUID.create(:food => food) }
  after_update { |food| FerretItemUID.update(food.uid) }

  NUTRIENT_ATTRIBUTES = {
    :vitamin_a => ["Vitamin A", "IU"],
    :vitamin_c => ["Vitamin C", "milligrams"],
    :calcium   => ["Calcium",   "milligrams"],
    :iron      => ["Iron",      "milligrams"]
  }

  NUTRIENT_ATTRIBUTES.each do |attribute, (name, unit)|
    eval "def #{attribute}
      @#{attribute} ||= Nutrient.new('#{name}','#{unit}', self[:#{attribute}])
    end"
    # def vitamin_c
    #   Nutrient.new("Vitamin C", "milligrams", self[:vitamin_c])
    # end

    eval "def #{attribute}=(value)
      @#{attribute} = Nutrient.new('#{name}','#{unit}', value)
      self[:#{attribute}] = @#{attribute}.value
      @#{attribute}
    end"
    # def vitamin_c=(value)
    #   @vitamin_c = Nutrient.new('Vitamin C','milligrams', value)
    #   self[:vitamin_c] = @vitamin_c.value
    #   @vitamin_c
    # end
    
    eval "def #{attribute}_daily_value
      #{attribute}.daily_value * 100
    end"
    # def vitamin_c_daily_value
    #   vitamin_c.daily_value * 100
    # end

    eval "def #{attribute}_daily_value=(daily_value)
      self.#{attribute} = UsdaNdb::DailyValues.new('#{name}')\
        .value_from_percent_daily((daily_value ? (daily_value.to_f / 100) : 0))\
        .convert_to('#{unit}').scalar
    end"
    # def vitamin_c_daily_value=(daily_value)
    # self.vitamin_c = UsdaNdb::DailyValues.new('Vitamin C')\
    #  .value_from_percent_daily((daily_value ? (daily_value / 100) : 0))\
    #  .convert_to('milligrams').scalar
  end

  def first_word_in_name
    return "" if name.blank?
    
    name.split(",").first.singularize
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
    result ||= usda_abbreviated_data.try(:measure, nutrient, serving_size)
  end
  
  def to_param  
    "#{self.id}-#{self.name.parameterize}"  
  end
end
