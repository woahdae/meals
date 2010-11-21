class DropTypeColumnOnFoods < ActiveRecord::Migration
  def self.up
    remove_column :foods, :type
  end

  def self.down
    add_column :foods, :type, :string
  end
end
