class Unit
  alias :orig_parse :parse
  # Adding the ability to parse complex fractions, i.e. "1 1/2 cups"
  def parse(string = "0")
    string =~ /^(.*) (\w+)$/
    str_to_parse = ($1 && $2) ? "#{Unit::Helper.complex_fraction_string_to_float($1)} #{$2}" : string
    orig_parse(str_to_parse)
  end
  
  # on Unit.new("1.5 pounds"), would return "1 1/2 lbs". If formatted_units is given,
  # it will return that unit string instead, so 'pounds' here would return "1 1/2 pounds"
  def to_fractional_s(formatted_units = nil)
    "#{Unit::Helper.float_to_fraction_string(self.scalar.to_f)} #{formatted_units || self.units}"
  end

  def self.base_unit(string)
    Unit.new(string).to_base.units
  end

  module Helper
    # given "1 1/2", would return 1.5
    def self.complex_fraction_string_to_float(string_fraction)
      complex_fraction = string_fraction =~ /^([0-9]+) ([0-9]+)\/([0-9]+)/
      return complex_fraction ? ($1.to_f + $2.to_f / $3.to_f) : string_fraction
      # eval(string_fraction.gsub(" ","+").gsub(/([0-9]+\/[0-9]+)$/, "\\1.0").to_s)
    end

    # given 1.5, would return "1 1/2"
    def self.float_to_fraction_string(float)
      Rational(*float.to_fraction).divmod(1).join(" ")
    end
  end
end