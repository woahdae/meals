class Food < ActiveRecord::Base
  has_many :receipt_items
  belongs_to :source, :polymorphic => true

  after_save    { |food| FerretFood.update(food) }
  after_destroy { |food| FerretFood.delete(food) }

  validates_format_of :name, :with => /,/, 
    :message => %(should be in 'tag' format from most generic to most specific, ex: "burrito, chicken fajita, trader joes")
  validates_presence_of :name, :servings
  validates_uniqueness_of :name, :on => :create

  validate :serving_size_is_a_unit
  validate :common_weight_is_mass
  validate :common_weight_description_is_volume

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

  def serving_size
    self[:serving_size].try(:to_unit)
  end

  def first_word_in_name
    return "" if name.blank?

    name.split(",").first.singularize
  end

  def grams_per_nutrient
    if serving_size.kind == :mass
      serving_size.convert_to('grams')
    elsif density
      UnitWithDensity.new(serving_size, :density => density).convert_to('grams')
    else
      serving_size
    end
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

  def average_price_per_serving
    return nil if average_price(serving_size * servings).nil?

    average_price(serving_size * servings) / servings
  end

  private

    def serving_size_is_a_unit
      begin
        if serving_size.present?
          errors.add(:serving_size, "must contain a unit (ex. #{self[:serving_size]} grams)") if serving_size.units.blank?
        else
          errors.add(:serving_size, "must be specified")
        end
      rescue => e
        if e.message.include?("Unit not recognized")
          errors.add(:serving_size, "'#{self[:serving_size]}' is not a valid unit")
        else
          raise
        end
      end
    end

    def common_weight_is_mass
      begin
        if common_weight.present? && common_weight.to_unit.kind != :mass
          errors.add(:common_weight, "must be a mass (ex. '5 grams')") 
        end
      rescue => e
        if e.message.include?("Unit not recognized")
          errors.add(:common_weight, "'#{common_weight}' is not a valid unit")
        else
          raise
        end
      end
    end

    def common_weight_description_is_volume
      begin
        if common_weight_description.present? && common_weight_description.to_unit.kind != :volume
          errors.add(:common_weight_description, "must be a volume (ex. '1 cup')") 
        end
      rescue => e
        if e.message.include?("Unit not recognized")
          errors.add(:common_weight_description, "'#{common_weight}' is not a valid unit")
        else
          raise
        end
      end
    end
  # /private
end