class List < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :recipes
  has_and_belongs_to_many :foods

  def measure(nutrient)
    result = recipes.inject(0) do |sum, recipe|
      measurement = recipe.measure(nutrient)
      return nil if measurement.nil?
      
      sum += measurement
    end
    # result += foods.inject(0) {|value, food| value += ((food.measure(nutrient))}
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
    recipes + foods
  end

  def combined_items
    unmergeable = []
    result = (foods + recipes.collect(&:items)).flatten.inject({}) do |h, item| 
      food_id = item.is_a?(Food) ? item.id : item.food_id

      if food_id.nil?
        unmergeable << item.clone
        next h
      end

      if h[food_id].present?
        begin
          h[food_id].qty = (h[food_id].qty.to_unit + (item.food.try(:volume_to_weight, item.qty) || item.qty.to_unit))
        end
      else
        if item.is_a?(Food)
          unmergeable << item.clone
          next h
        else
          h[food_id] = item.clone
        end
      end

      h
    end.values + unmergeable

    result.sort_by(&:name)
  end

  def missing
    {}
  end

  def completion
    recipes.inject(1) {|comp, recipe| comp * recipe.completion}
  end
end
