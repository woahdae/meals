class Food < ActiveRecord::Base
  has_many :receipt_items

  after_save    { |food| FerretFood.update(food) }
  after_destroy { |food| FerretFood.delete(food) }

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
    # end
  end

  def common_weight
    self[:common_weight].to_unit('grams')
  end

  def first_word_in_name
    return "" if name.blank?

    name.split(",").first.singularize
  end

  def qty
    raise 'abstract method'
  end

  def grams_per_nutrient
    raise "abstract method"
  end

  def measure(nutrient, amount = nil)
    'abstract method'
  end

  def average_price_per_unit(unit)
    return nil if average_price_per_base_unit.nil?

    average_price_per_base_unit.convert_to("USD/#{unit.to_unit.units}")
  end

  def average_price_per_base_unit
    return nil if receipt_items.empty?

    receipt_items.collect(&:price_per_base_unit).sum / receipt_items.size
  end

  def average_price(given_qty = nil)
    relevant_qty = given_qty || self.qty
    return nil if average_price_per_base_unit.nil? || relevant_qty.blank?

    relevant_qty.to_unit.to_base * average_price_per_base_unit
  end

  def to_param  
    "#{self.id}-#{self.name.parameterize}"  
  end
end
