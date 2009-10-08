# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div, flash[msg.to_sym], :id => "flash-#{msg}", :class => msg) unless flash[msg.to_sym].blank?
    end
    messages
  end

  def display_sidebar?
    controller.controller_name == "recipes" && !["new","edit","update"].include?(controller.action_name)
  end
  
  def float_to_minute(num)
    num ? num.to_i.to_s + "m" : "?"
  end
  
  def round_unit(unit)
    unit.scalar = unit.scalar.round(3)
    return unit
  end
  
  def float_to_price(float)
    "$" + "%.2f" % float
  end
  
  def user_owns_recipe?(recipe)
    current_user && recipe.user_id == current_user.id
  end
end
