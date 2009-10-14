module RecipesHelper
  def attr_with_unit(object, attribute)
    value = attr_as_fraction(object, attribute)
    "#{value} #{object.send(attribute.to_s + '_unit')}" if value
  end
  
  def attr_as_fraction(object, attribute)
    value = object.send(attribute)
    (Rational(*(0.5.to_fraction)).divmod 1).join(" ").gsub(/^0 /,"") if value
  end
  
  def main_photo_path(recipe, default_image = "/images/empty_bowl.jpg")
    photo = recipe.photos.first
    (photo.nil? || photo.new_record?) ? default_image : recipe.photos.first.public_filename(:medium)
  end
end
