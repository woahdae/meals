module RecipesHelper
  DEFAULT_RECIPE_IMAGE = "/images/empty_bowl.jpg"
  
  def attr_with_unit(object, attribute)
    value = attr_as_fraction(object, attribute)
    "#{value} #{object.send(attribute.to_s + '_unit')}" if value
  end
  
  def attr_as_fraction(object, attribute)
    value = object.send(attribute)
    (Rational(*(0.5.to_fraction)).divmod 1).join(" ").gsub(/^0 /,"") if value
  end
  
  def link_to_highslide_image(object, thumb_size, enlarge_size, options = {})

    photo = object.is_a?(Photo) ? object : object.photos.first
    
    thumb_path = photo_path_or_default(photo, :size => thumb_size)
    big_path   = photo_path_or_default(photo, :size => enlarge_size)
    
    img_tag = image_tag(thumb_path, :class => "#{thumb_size}", :alt => (photo && photo.caption || ""))

    if thumb_path == DEFAULT_RECIPE_IMAGE
      return options[:hide_default] ? "" : img_tag
    else
      return link_to(img_tag, big_path, 
        :onclick => "return hs.expand(this#{", { slideshowGroup: '#{options[:gallery]}' }" if options[:gallery]})")
    end
  end
  
  def photo_path_or_default(photo, options = {})
    options[:default_image] ||= DEFAULT_RECIPE_IMAGE
    
    (photo.nil? || photo.new_record?) ? options[:default_image] : photo.public_filename(options[:size])
  end
  
  def completion_circle(completion, missing = {})
    title = "#{(completion * 100).to_i}% Complete."
    title += " #{missing_info_table(missing)}" if missing.present?
    content_tag(:span, " ", 
      :class => "circle", 
      :style => "background-color:#{completion_to_color(completion)}",
      :title => title)
  end
  
  def completion_to_color(completion)
    red = 255 - (255 * completion)
    green = 254 - (127 * completion)
    
    return "#" + ("%02x" % red) + ("%02x" % green) + "00"
  end
  
  def missing_info_table(missing_info)
    table = []
    table << "No Photos" if missing_info['photos']
    table << "Missing UIDs: #{missing_info['food'].collect(&:name).join(', ')}" if missing_info['food']
    table << "Missing receipts: #{missing_info['receipts'].collect(&:name).join(", ")}" if missing_info['receipts']
    table.join("; ")
  end
end
