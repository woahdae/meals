class RemoveMealPlans < ActiveRecord::Migration
  def self.up
    drop_table :meal_plans
  end

  def self.down
    create_table "meal_plans", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
  end
end
