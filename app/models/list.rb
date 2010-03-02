class List < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :recipes
  has_and_belongs_to_many :item_uids, :class_name => "ItemUID"
  
  def measure(nutrient)
    result =  recipes.inject(0)   {|value, recipe| value += recipe.measure(nutrient)}
    # result += item_uids.inject(0) {|value, item_uid| value += ((item_uid.measure(nutrient))}
  end
  
  def combined_items
    recipes.collect(&:items).flatten.inject({}) do |h, item| 
      uid = item.item_uid_id
      
      if h[uid].present?
        h[uid].qty = (h[uid].qty.to_unit + item.qty.to_unit)
      else
        h[uid] = item.clone
      end
      
      h
    end.values
  end
end
