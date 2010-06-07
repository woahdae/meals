class Nutrient
  attr_reader :name, :unit, :value
  
  def initialize(name, unit, value)
    @name, @unit, @value = name, unit, (value || 0)
  end

  def daily_value
    UsdaNdb::DailyValues.new(@name).percent_daily_value(@value)
  end

  def to_s
    "#{@name}: #{to_unit}"
  end

  def to_unit
    @value.to_unit(@unit)
  end
end