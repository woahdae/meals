class ListItem < ActiveRecord::Base
  belongs_to :list
  belongs_to :food
  belongs_to :recipe

  validates_presence_of :name

  def measure(nutrient)
    food.try(:measure, nutrient, qty)
  end
end