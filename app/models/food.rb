class Food < ActiveRecord::Base
  has_many :receipt_items

  after_save    { |food| FerretFood.update(food) }
  after_destroy { |food| FerretFood.delete(food) }

  NUTRIENT_ATTRIBUTES = {
    :vitamin_a           => ["Vitamin A", "IU"],
    :vitamin_c           => ["Vitamin C", "milligrams"],
    :calcium             => ["Calcium",   "milligrams"],
    :iron                => ["Iron",      "milligrams"],
    :fat                 => ["Total fat", "grams"],
    :saturated_fat       => ["Saturated fat", "grams"],
    :carbs               => ["Total carbohydrate", "grams"],
    :fiber               => ["Dietary fiber", "grams"],
    :protein             => ["Protein", "grams"]
  }

  NUTRIENT_ATTRIBUTES.each do |attribute, (name, unit)|
    eval "def #{attribute}_daily_value(qty = nil)
      if new_record?
        0
      else
        qty = measure(:#{attribute}, qty || grams_per_nutrient)
        UsdaNdb::DailyValues.new('#{name}').percent_daily_value(qty || 0) * 100
      end
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

  def kcal_daily_value(qty)
    if kcal
      qty = measure(:kcal, qty)
      (qty / 2000) * 100
    end
  end

  def kcal_daily_value=(kcal_dv)
    self.kcal = (kcal_dv * 2000) / 100
  end

  def fat_kcal_daily_value(qty)
    if fat_kcal
      qty = measure(:fat_kcal, qty)
      (qty / 585) * 100
    end
  end

  def fat_kcal_daily_value=(kcal_dv)
    self.fat_kcal = (kcal_dv * 585) / 100
  end

  def common_weight
    self[:common_weight].try(:to_unit, 'grams')
  end

  def first_word_in_name
    return "" if name.blank?

    name.split(",").first.singularize
  end

  def grams_per_nutrient
    nil
  end

  def measure(nutrient, amount = grams_per_nutrient)
    if self.send(nutrient)
      if density
        (self.send(nutrient) / grams_per_nutrient.scalar) * 
          UnitWithDensity.new(amount, :density => density)\
          .convert_to('grams').scalar
      else
        amount = amount.to_unit.convert_to(grams_per_nutrient.units)
        self.send(nutrient) / grams_per_nutrient * amount
      end
    end
  end

  def daily_value(nutrient, qty = grams_per_nutrient)
    self.send("#{nutrient}_daily_value", qty)
  end

  def volume_per_nutrient
    grams_per_nutrient / density if density
  end

  def density
    common_weight / common_volume if common_weight && common_volume
  end

  def average_price(qty = grams_per_nutrient)
    return nil if average_unit_price.nil?

    average_unit_price.unit * 
      UnitWithDensity.new(qty, :density => density)\
      .convert_to(average_unit_price.denominator)
  end

  def average_unit_price
    return nil if receipt_items.empty?

    receipt_items.to_a.sum do |ri|
      CompoundUnit.new(
        :numerator   => ri.price.to_unit('dollar'),
        :denominator => UnitWithDensity.new(ri.qty, :density => density))
    end / receipt_items.size
  end

  def common_volume
    return nil if common_weight_description.nil?
    
    common_weight_description.split(",").first.to_unit
  rescue => e
    if e.message.include?('Unit not recognized')
      return nil
    else
      raise
    end
  end

  def to_param  
    "#{self.id}-#{self.name.parameterize}"
  end
end