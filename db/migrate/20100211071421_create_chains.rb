class CreateChains < ActiveRecord::Migration
  def self.up
    create_table :chains do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :chains
  end
end
