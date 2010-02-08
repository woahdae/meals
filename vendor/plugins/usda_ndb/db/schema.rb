# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100208052716) do

  create_table "item_uids", :force => true do |t|
    t.integer "usda_ndb_id"
    t.integer "our_ndb_id"
  end

  add_index "item_uids", ["our_ndb_id"], :name => "index_item_uids_on_our_ndb_id"
  add_index "item_uids", ["usda_ndb_id"], :name => "index_item_uids_on_usda_ndb_id"

  create_table "items", :force => true do |t|
    t.string   "name"
    t.float    "amount"
    t.string   "amount_unit"
    t.decimal  "bulk_price",    :precision => 10, :scale => 2
    t.float    "bulk_qty"
    t.string   "bulk_qty_unit"
    t.integer  "calories"
    t.float    "fat"
    t.float    "carbs"
    t.float    "protein"
    t.integer  "recipe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_uid_id"
  end

  add_index "items", ["item_uid_id"], :name => "index_items_on_item_uid_id"

  create_table "meal_plans", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
