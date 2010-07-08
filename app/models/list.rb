class List < ActiveRecord::Base
  belongs_to :user
  has_many :list_items
  has_many :foods, :through => :list_items do
    def summary
      where("list_items.recipe_id IS NULL")
    end
  end
  has_many :recipes, :through => :list_items do
    def summary
      group("recipes.id")
    end
  end

  def measure(nutrient)
    list_items.inject(0) do |sum, item|
      measurement = item.measure(nutrient)
      return nil if measurement.nil?
      
      sum += measurement
    end
  end

  def daily_value(nutrient)
    list_items.to_a.sum do |item|
      measurement = item.daily_value(nutrient)
      return nil if measurement.nil?

      measurement
    end
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

  def summary_items
    recipes.summary + foods.summary
  end

  def add_recipe(recipe)
    recipe.items.each do |item|
      if item.food_id && existing = list_items.to_a.find {|li| li.food_id == item.food_id}
        existing.update_attributes(
          :qty => (item.qty_with_density + existing.qty.to_unit).unit.to_s)
      else
        list_items.create(
          :recipe_id => recipe.id,
          :food_id   => item.food_id,
          :qty       => item.qty,
          :name      => item.name )
      end
    end
  end

  def add_food(food)
    list_items.create(
      :food_id => food.id,
      :qty     => food.qty.to_s,
      :name    => food.name)
  end

  def missing
    {}
  end

  def completion
    recipes.inject(1) {|comp, recipe| comp * recipe.completion}
  end
end
