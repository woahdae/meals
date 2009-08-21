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
    controller.controller_name == "recipes" && !["new","edit","show","update"].include?(controller.action_name)
  end
end
