class AddTypeToFood < ActiveRecord::Migration
  def self.up
    add_column :foods, :type, :string
    rename_column :foods, :grams, :common_weight
    rename_column :foods, :volume, :common_weight_description
    
    add_index :foods, :type
    
    Food.update_all('type = "UsdaNdbFood"','usda_ndb_id IS NOT NULL')
    Food.update_all('type = "UserFood"','usda_ndb_id IS NULL')
  end

  def self.down
    remove_index :foods, :type
    rename_column :foods, :common_weight_description, :volume
    rename_column :foods, :common_weight, :grams
    remove_column :foods, :type
  end
end
