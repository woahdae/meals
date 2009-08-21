module ActsAsUnitable
  class NoUnitError < StandardError;end
  
  def parse_unitable_string(value)
    value =~ /^(.*) (\w.+)$/
    return fraction_string_to_float($1), $2
  end
  
  def acts_as_unitable(*methods)
    methods.each do |method|
      define_method("#{method}_with_unit".to_sym) do
        desired_unit = self["#{method}_unit".to_sym]
        
        return self[method] if desired_unit.blank?
        
        base_unit = self[method].send(:to_unit, Unit.base_unit(desired_unit))
        return base_unit.convert_to(desired_unit)
      end
      
      define_method("#{method}_with_unit=".to_sym) do |value|
        # return if value.is_a?(String) && value.blank?
        
        if value.is_a?(String)
          unit = Unit.new(value)
          value =~ /^(.*) (\w+)$/
          desired_units = $2
        elsif value.respond_to?(:scalar) && value.units
          unit = value
          desired_units = value.units
        else
          raise NoUnitError, "pass in a string or Unit instance"
        end

        self[method] = unit.base_scalar
        self["#{method}_unit".to_sym] = self.attributes["#{method}_unit"] || desired_units
      end
    end
  end
end

class ActiveRecord::Base
  require 'ruby-units'
  require 'float_extensions'
  require 'unit_extensions'
  
  extend ActsAsUnitable
end
