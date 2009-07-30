module ItemsHelper
  def item_html_id(item)
    id = item.id || (@random_id ||= rand(9999999))
    "item_#{id}"
  end
end
