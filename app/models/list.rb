class List < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :recipes
  has_and_belongs_to_many :item_uids, :class_name => "ItemUID"
  
  def measure(nutrient)
    result =  recipes.inject(0)   {|value, recipe| value += recipe.measure(nutrient)}
    # result += item_uids.inject(0) {|value, item_uid| value += ((item_uid.measure(nutrient))}
  end

  def average_price
    recipes.to_a.sum(&:average_price)
  end
  
  def average_price_per_serving
    recipes.to_a.sum(&:average_price_per_serving)
  end

  def servings
    recipes.to_a.sum(&:servings)
  end
  
  def serving_size
    recipes.to_a.sum(&:serving_size) rescue nil
  end
  
  def items
    recipes + item_uids
  end
  
  def combined_items
    unmergeable = []
    result = (item_uids.collect(&:food) + recipes.collect(&:items)).flatten.inject({}) do |h, item| 
      if item.uid.nil?
        unmergeable << item.clone
        next h
      end
      
      uid = item.uid.id
      
      if h[uid].present?
        begin
          h[uid].qty = (h[uid].qty.to_unit + (item.uid.try(:volume_to_weight, item.qty) || item.qty.to_unit))
        rescue
          unmergeable << item.clone
        end
      else
        h[uid] = item.clone
      end
      
      h
    end.values + unmergeable
    
    result.sort_by(&:name)
  end
end
