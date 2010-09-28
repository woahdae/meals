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
    Measurement.new(0).tap do |measure|
      list_items.each do |item|
        if item.measure(nutrient).nil?
          measure.missing << item
        else
          measure.items["#{item.name} (#{(item.qty.to_unit).round(2)})"] = item.measure(nutrient).round
          measure.value += item.measure(nutrient)
        end
      end
    end
  end

  def daily_value(nutrient)
    list_items.to_a.sum do |item|
      measurement = item.daily_value(nutrient)
      return nil if measurement.nil?

      measurement
    end
  end

  def average_unit_price
    Measurement.new(0.to_unit("dollar")).tap do |measure|
      list_items.each do |item|
        if item.average_price.nil?
          measure.missing << item
        else
          measure.items["#{item.name} (#{(item.qty.to_unit).round(2)})"] = item.average_price.round(2)
          measure.value += item.average_price
        end
      end
    end
  end

  def servings
    Measurement.new(0).tap do |servings|
      recipes.summary.each do |item|
        if !item.respond_to?(:servings) || item.servings.nil?
          servings.missing << item
        else
          servings.items[item.name] = item.servings
          servings.value += item.servings
        end
      end
      foods.summary.each do |item|
        if !item.respond_to?(:servings) || item.servings.nil?
          servings.missing << item
        else
          qty = list_items.to_a.find {|li| li.food_id == item.id}.qty
          est_servings = (UnitWithDensity.new(qty, :density => item.density) / item.serving_size).scalar
          servings.items[item.name] = est_servings
          servings.value += est_servings
        end
      end
    end
  end

  def serving_size
    nil
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

  def add_food(food, qty = nil)
    if existing = list_items.to_a.find {|li| li.food_id == food.id}
      existing.update_attributes(
        :qty => (existing.qty.to_unit + (qty || food.qty.to_s)).unit.to_s)
    else
      list_items.create(
        :food_id => food.id,
        :qty     => qty || food.qty.to_s,
        :name    => food.name)
    end
  end

  def missing
    {}
  end

  def completion
    recipes.inject(1) {|comp, recipe| comp * recipe.completion}
  end
end
