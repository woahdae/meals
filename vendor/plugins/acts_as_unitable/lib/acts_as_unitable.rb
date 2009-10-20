module ActsAsUnitable
  class NoUnitError < StandardError;end
  
  def parse_unitable_string(value)
    value =~ /^(.*) (\w.+)$/
    return fraction_string_to_float($1), $2
  end
  
  def validates_as_unit(*methods)
    options = methods.pop if methods.last.is_a?(Hash)
    options ||= {}

    methods.each do |method|
      validate do |record|
        desired_unit = record.send("#{method}_unit".to_sym)
        begin
          Unit.new(desired_unit)
        rescue ArgumentError => e
          if e.message.match("No Unit Specified")
            record.errors.add("#{method}_with_unit", "not specified") unless options[:allow_blank]
          elsif e.message.match("Unit")
            unless options[:allow_blank] && desired_unit.blank?
              record.errors.add("#{method}_with_unit", "'#{desired_unit}' is not a valid unit of measurement")
            end
          else
            raise e
          end
        end
      end
    end
  end
  
  def acts_as_unitable(*methods)
    methods.each do |method|
      define_method("#{method}_with_unit".to_sym) do
        begin
          desired_unit = self["#{method}_unit".to_sym]
        
          return self[method] if desired_unit.blank?
        
          base_unit = self[method].send(:to_unit, Unit.base_unit(desired_unit))
          return base_unit.convert_to(desired_unit)
        rescue ArgumentError => e
          if e.message.match("Unit not recognized") || e.message.match("No Unit Specified")
            return self[method]
          else
            raise e
          end
        end
      end
      
      define_method("#{method}_with_unit=".to_sym) do |value|
        begin
          if value.is_a?(String)
            value =~ /^(.*) (\w+)$/
            desired_units = $2
            quantity = $1
            unit = Unit.new(value)
          elsif value.respond_to?(:scalar) && value.units
            desired_units = value.units
            quantity = value.scalar
            unit = value
          else
            raise NoUnitError, "pass in a string or Unit instance"
          end

          self[method] = unit.base_scalar
          self["#{method}_unit".to_sym] = self.attributes["#{method}_unit"] || desired_units
        rescue ArgumentError => e
          if e.message.match("Unit not recognized") || e.message.match("No Unit Specified")
            self[method] = quantity
            self["#{method}_unit".to_sym] = desired_units
          else
            raise e
          end
        end
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
