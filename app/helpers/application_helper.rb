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
  end
  
  def float_to_price(object, method, *args)
    price = object.send(method, *args)
    (price.present? && price != 0.0) ? "$" + "%.2f" % price : "?"
  rescue => e
    if e.message.match("Incompatible Units")
      return nil
    else
      raise e
    end
  end
  
  def options_for_item_uid_select(item_uids, selected)
    return [] if item_uids.blank?
    prompt = <<-EOS
    "<option #{selected.blank? ? "selected='selected'" : ""}'>
      -- Select Item UID --
    </option>"
    EOS
    prompt + options_from_collection_for_select(item_uids, :id, :name, selected.to_s)
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
  
  def html_id(record)
    "#{record.class.table_name}_#{record.id}"
  end
  
  def facebook_pic(user)
    return "" if !user.facebook_user?
    
    %(<fb:profile-pic uid="#{user.fb_id}" facebook-logo="true" size="thumb" ></fb:profile-pic>)
  end
end
