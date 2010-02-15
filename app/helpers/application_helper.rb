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
  
  def options_for_item_uid_select(item_uids, selected)
    return [] if item_uids.blank?
    "<option #{selected == 'NONE' || selected.blank? ? "selected='selected'" : ""}'></option>" + 
      options_from_collection_for_select(item_uids, :id, :name, selected.to_s)
  end
  
  # parent can be recipe or receipt
  def observe_item_name_for_select(parent, selected)
    @nested_item_index ||= 0
    
    prefix = "#{parent}_items_attributes_#{@nested_item_index}"
    @nested_item_index += 1
    observe_field("#{prefix}_name", 
      :url => { :controller => "/item_uids", :action => "search" }, 
      :method => :get,
      :update => "#{prefix}_item_uid_id", 
      :with => "'name=' + value + '&selected=#{selected}'" )
  end
end
