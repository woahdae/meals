module RecipesHelper
  def attr_with_unit(object, attribute)
    value = attr_as_fraction(object, attribute)
    "#{value} #{object.send(attribute.to_s + '_unit')}" if value
  end
  
  def attr_as_fraction(object, attribute)
    value = object.send(attribute)
    (Rational(*(0.5.to_fraction)).divmod 1).join(" ").gsub(/^0 /,"") if value
  end
  
  def main_photo_path(recipe, options = {})
    photo = recipe.photos.first
    photo_path_or_default(photo, options)
  end
  
  def photo_path_or_default(photo, options = {})
    options[:default_image] ||= "/images/empty_bowl.jpg"
    
    (photo.nil? || photo.new_record?) ? options[:default_image] : photo.public_filename(options[:size])
  end
end
