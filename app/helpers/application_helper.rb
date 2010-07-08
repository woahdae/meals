# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div,
        flash[msg.to_sym],
        :id => "flash-#{msg}",
        :class => "flash #{msg}") unless flash[msg.to_sym].blank?
    end
    messages.join.html_safe
  end

  def display_sidebar?
    true #controller.controller_name == "recipes" && !["new","edit","update"].include?(controller.action_name)
  end

  def default_page_title
    controller.controller_name.titleize + " &bull " + controller.action_name.titleize
  end

  def float_to_minute(object, method)
    num = object.send(method)
    num = num.scalar if num.respond_to?(:scalar)
    num ? num.to_i.to_s + "m" : "?"
  end
  
  def float_to_price(object, method, *args)
    price = object.send(method, *args)
    (price.present? && price != 0.0) ? "$" + "%.2f" % price : "?"
  rescue => e
    if e.message.match("Incompatible Units")
      return "?"
    else
      raise e
    end
  end

  def unit_to_price(object, method, *args)
    unit = object.send(method, *args)
    (unit.present? && unit.scalar != 0.0) ? "$" + "%.2f" % unit.scalar + " #{unit.units}" : "?"
  rescue => e
    if e.message.match("Incompatible Units")
      return "?"
    else
      raise e
    end
  end

  def measure_nutrient(record, nutrient, unit = nil)
    measurement = record.measure(nutrient)
    if measurement.nil?
      return "?"
    elsif measurement.is_a?(Measurement)
      content_tag(:span, "#{measurement} #{unit.to_s}",
        :tooltip => nutrient_breakdown(measurement, unit))
    else
      "#{measurement.round} #{unit.to_s}"
    end
  end

  def nutrient_breakdown(measurement, unit = nil)
    content_tag(:table) do
      measurement.items_with_missing.sum do |item|
        content_tag(:tr) do
          content_tag(:td, item.first) + # nutrient name
            content_tag(:td, item.last.to_s + unit.to_s) # value
        end
      end
    end
  end

  def daily_value(record, nutrient)
    return "?" if record.daily_value(nutrient).nil?
    "#{record.daily_value(nutrient).round}%"
  end

  def serving_amount(record)
    if record.respond_to?(:grams_per_nutrient)
      grams = record.grams_per_nutrient.round
      volume = record.volume_per_nutrient
      if volume
        volume = volume.scalar.round(2).to_unit(volume.unit)
        content_tag(:span, grams, :tooltip => volume)
      else
        content_tag(:span, grams)
      end
    else
      'Serving'
    end
  end

  def options_for_food_select(foods, selected)
    return "" if foods.blank?

    prompt = <<-EOS
    "<option #{selected.blank? ? "selected='selected'" : ""}'>
      -- Select Food --
    </option>"
    EOS
    (prompt + options_from_collection_for_select(foods, :id, :name, selected.to_s)).html_safe
  end

  def html_id(record)
    "#{record.class.table_name}_#{record.id}"
  end

  def facebook_pic(user)
    return "" if !user.facebook_user?

    image_tag("http://graph.facebook.com/#{user.fb_id}/picture")
  end

  def facebook_login_button
    content_tag(:div, :id => "facebook_login") do
      link_to(
        content_tag(:span, "Login", :class => "fb_button_text"), 
        FacebookUser.new.auth_url, 
        :class => "fb_button fb_button_medium" )
    end
  end

  def add_to_list_button(record)
    str = form_tag(
      add_lists_path("#{record.class.table_name.singularize}_id".to_sym => record.id),
      :class => "link_form",
      :remote => true)
    str << label_tag(:submit, submit_tag("Add to list"), :class => "link_button")
    str << "</form>".html_safe
  end

  def remove_item_from_list_button(record)
    str = form_tag(list_item_path(record),
      :method => :delete,
      :class => "link_form",
      :remote => true)
    str << hidden_field_tag("_method","delete") # needed for webrat on iphone :(
    str << label_tag(:submit, submit_tag("X", :id => "delete_#{html_id(record)}"),
      :class => "link_button")
    str << "</form>".html_safe
  end
end