class CompoundUnit
  attr_reader :unit, :numerator, :denominator

  delegate :to_s, :scalar, :units, :to => :unit

  def initialize(options)
    @numerator   = options[:numerator]
    @numerator   = @numerator.to_unit if @numerator.is_a?(String)
    @denominator = options[:denominator]
    @denominator = @denominator.to_unit if @denominator.is_a?(String)
  end

  def +(other)
    other = other.convert_to(self)
    self.class.new(
      :numerator => numerator + other.numerator,
      :denominator => denominator)
  end

  def /(other)
    other = other.convert_to(self) if other.respond_to?(:convert_to)

    self.class.new(
      :numerator => numerator / other.numerator,
      :denominator => denominator)
  end

  def *(other)
    other = other.convert_to(self) if other.respond_to?(:convert_to)

    self.class.new(
      :numerator => numerator * other.numerator,
      :denominator => denominator)
  end

  def convert_to(other)
    new_denom = denominator.convert_to(other.denominator)
    multiplier = other.denominator / new_denom
    self.class.new(
      :numerator   => multiplier * numerator,
      :denominator => multiplier * new_denom)
  end

  def unit
    numerator / denominator
  end
  alias :to_unit :unit

  def ==(other)
    unit == other.unit
  end
end
