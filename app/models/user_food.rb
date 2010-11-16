class UserFood < Food
  belongs_to :user

  validates_format_of :name, :with => /,/, 
    :message => %(should be in 'tag' format from most generic to most specific, ex: "burrito, chicken fajita, trader joes")
  validates_presence_of :name, :servings
  validates_uniqueness_of :name, :on => :create

  validate :serving_size_is_a_unit
  validate :common_weight_is_mass
  validate :common_weight_description_is_volume
  
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
  private :serving_size_is_a_unit

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
  private :common_weight_is_mass

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
  private :common_weight_description_is_volume

  def grams_per_nutrient
    if serving_size.kind == :mass
      serving_size.convert_to('grams')
    elsif density
      UnitWithDensity.new(serving_size, :density => density).convert_to('grams')
    else
      serving_size
    end
  end

  def serving_size
    self[:serving_size].try(:to_unit)
  end
  alias :common_measure :serving_size

  def average_price_per_serving
    return nil if average_price(serving_size * servings).nil?

    average_price(serving_size * servings) / servings
  end
end