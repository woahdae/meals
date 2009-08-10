module RecipesHelper
  def attr_with_unit(object, attribute)
    value = attr_as_fraction(object, attribute)
    "#{value} #{object.send(attribute.to_s + '_unit')}" if value
  end
  
  def attr_as_fraction(object, attribute)
    value = object.send(attribute)
    (Rational(*(0.5.to_fraction)).divmod 1).join(" ").gsub(/^0 /,"") if value
  end
end
