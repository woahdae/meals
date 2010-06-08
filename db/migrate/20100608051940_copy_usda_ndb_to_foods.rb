require 'ruby-debug'
class CopyUsdaNdbToFoods < ActiveRecord::Migration
  def self.up
    add_column :foods, :grams, :float
    add_column :foods, :volume, :string

    add_column :foods, :usda_ndb_id, :integer

    UsdaNdb::AbbreviatedData.find_each do |datum|
      description = UsdaNdb::FoodDescription.find(datum.id)
      Food.new(
        "name"                => description.long_description,
        "usda_ndb_id"         => datum.id,
        "kcal"                => datum.kcal,
        "fat"                 => datum.fat,
        "saturated_fat"       => datum.saturated_fat,
        "monounsaturated_fat" => datum.monounsaturated_fat,
        "polyunsaturated_fat" => datum.polyunsaturated_fat,
        "cholesterol"         => datum.cholesterol,
        "carbs"               => datum.carbs,
        "protein"             => datum.protein,
        "sugar"               => datum.sugar,
        "fiber"               => datum.fiber,
        "fat_kcal"            => description.fat_factor.present? ? (datum.fat * description.fat_factor) : nil,
        "sodium"              => datum.sodium,
        "vitamin_a"           => datum.vitamin_a_iu,
        "vitamin_c"           => datum.vitamin_c,
        "calcium"             => datum.calcium,
        "iron"                => datum.iron,
        "grams"               => datum.weight_1,
        "volume"              => datum.weight_1_description
      ).save(false)
    end
  rescue
    debugger
    raise
  end

  def self.down
    UsdaNdb::AbbreviatedData.find_each do |datum|
      Food.find_by_usda_ndb_id(datum.id).try(:destroy)
    end
    
    remove_column :foods, :usda_ndb_id
    remove_column :foods, :volume
    remove_column :foods, :grams
  end
end
