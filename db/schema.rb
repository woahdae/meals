# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101117033100) do

  create_table "foods", :force => true do |t|
    t.string   "name"
    t.float    "kcal"
    t.float    "fat"
    t.float    "saturated_fat"
    t.float    "monounsaturated_fat"
    t.float    "polyunsaturated_fat"
    t.float    "cholesterol"
    t.float    "carbs"
    t.float    "protein"
    t.float    "sugar"
    t.float    "fiber"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "serving_size"
    t.integer  "servings"
    t.float    "fat_kcal"
    t.float    "sodium"
    t.float    "vitamin_a"
    t.float    "vitamin_c"
    t.float    "calcium"
    t.float    "iron"
    t.float    "common_weight"
    t.string   "common_weight_description"
    t.integer  "usda_ndb_id"
    t.string   "type"
  end

  add_index "foods", ["type"], :name => "index_foods_on_type"
  add_index "foods", ["user_id"], :name => "index_foods_on_user_id"

  create_table "foods_lists", :id => false, :force => true do |t|
    t.integer "food_id"
    t.integer "list_id"
  end

  add_index "foods_lists", ["food_id", "list_id"], :name => "index_foods_lists_on_food_id_and_list_id"

  create_table "item_uids", :force => true do |t|
    t.integer "usda_ndb_id"
    t.integer "food_id"
  end

  add_index "item_uids", ["food_id"], :name => "index_item_uids_on_food_id"
  add_index "item_uids", ["usda_ndb_id"], :name => "index_item_uids_on_usda_ndb_id"

  create_table "item_uids_lists", :id => false, :force => true do |t|
    t.integer "item_uid_id"
    t.integer "list_id"
  end

  add_index "item_uids_lists", ["item_uid_id", "list_id"], :name => "index_item_uids_lists_on_item_uid_id_and_list_id"

  create_table "items", :force => true do |t|
    t.string   "name"
    t.decimal  "bulk_price",  :precision => 10, :scale => 2
    t.integer  "calories"
    t.float    "fat"
    t.float    "carbs"
    t.float    "protein"
    t.integer  "recipe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_uid_id"
    t.string   "qty"
    t.integer  "food_id"
  end

  add_index "items", ["food_id"], :name => "index_items_on_food_id"
  add_index "items", ["item_uid_id"], :name => "index_items_on_item_uid_id"

  create_table "list_items", :force => true do |t|
    t.integer  "list_id"
    t.integer  "food_id"
    t.integer  "recipe_id"
    t.string   "qty"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "list_items", ["food_id"], :name => "index_list_items_on_food_id"
  add_index "list_items", ["list_id"], :name => "index_list_items_on_list_id"
  add_index "list_items", ["recipe_id"], :name => "index_list_items_on_recipe_id"

  create_table "lists", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lists", ["user_id"], :name => "index_lists_on_user_id"

  create_table "lists_recipes", :id => false, :force => true do |t|
    t.integer "recipe_id"
    t.integer "list_id"
  end

  add_index "lists_recipes", ["recipe_id", "list_id"], :name => "index_lists_recipes_on_recipe_id_and_list_id"

  create_table "photos", :force => true do |t|
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "photoable_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "caption"
  end

  add_index "photos", ["parent_id"], :name => "index_photos_on_parent_id"
  add_index "photos", ["photoable_id"], :name => "index_photos_on_photoable_id"
  add_index "photos", ["type"], :name => "index_photos_on_type"

  create_table "receipt_items", :force => true do |t|
    t.integer  "item_uid_id"
    t.string   "name"
    t.decimal  "price",       :precision => 10, :scale => 2
    t.integer  "receipt_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "qty"
    t.string   "food_id"
  end

  add_index "receipt_items", ["food_id"], :name => "index_receipt_items_on_food_id"
  add_index "receipt_items", ["item_uid_id"], :name => "index_receipt_items_on_item_uid_id"
  add_index "receipt_items", ["receipt_id"], :name => "index_receipt_items_on_receipt_id"

  create_table "receipts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "receipts", ["store_id"], :name => "index_receipts_on_store_id"
  add_index "receipts", ["user_id"], :name => "index_receipts_on_user_id"

  create_table "recipes", :force => true do |t|
    t.string   "name"
    t.float    "prep_time"
    t.float    "cook_time"
    t.integer  "servings"
    t.text     "directions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "stores", :force => true do |t|
    t.string   "street"
    t.string   "state"
    t.string   "city"
    t.string   "zip"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.integer  "fb_id",                     :limit => 8
    t.string   "fb_email"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
