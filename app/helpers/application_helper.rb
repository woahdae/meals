# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div, flash[msg.to_sym], :id => "flash-#{msg}", :class => "flash #{msg}") unless flash[msg.to_sym].blank?
    end
    messages
  end

  def display_sidebar?
    true #controller.controller_name == "recipes" && !["new","edit","update"].include?(controller.action_name)
  end
  
  def float_to_minute(object, method)
    num = object.send(method)
    num = num.scalar if num.respond_to?(:scalar)
    num ? num.to_i.to_s + "m" : "?"
  rescue IncalculableMetricError
    "?"
  end
  
  def round_unit(unit)
    return "" if unit.nil?
    
    unit.scalar = unit.scalar.round(3)
    return unit
  end
  
  def float_to_price(object, method)
    price = object.send(method)
    (price.present? && price != 0.0) ? "$" + "%.2f" % price : ":?"
  rescue IncalculableMetricError
    "?"
  rescue => e
    if e.message.match("Incompatible Units")
      return nil
    else
      raise e
    end
  end
end
