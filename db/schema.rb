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

  create_table "abbreviated_data", :id => false, :force => true do |t|
    t.integer "ndb_no"
    t.string  "short_description",    :limit => 120
    t.float   "water"
    t.integer "kcal"
    t.float   "protein"
    t.float   "fat"
    t.float   "ash"
    t.float   "carbs"
    t.float   "fiber"
    t.float   "sugar"
    t.integer "calcium"
    t.float   "iron"
    t.float   "magnesium"
    t.integer "phosphorus"
    t.integer "potassium"
    t.integer "sodium"
    t.float   "zinc"
    t.float   "copper"
    t.float   "manganese"
    t.float   "selenium"
    t.float   "vitamin_c"
    t.float   "thiamin"
    t.float   "riboflavin"
    t.float   "niacin"
    t.float   "pantothenic_acid"
    t.float   "vitamin_b6"
    t.float   "folate_total"
    t.float   "folic_acid"
    t.float   "food_folate"
    t.float   "folate_dfe"
    t.float   "choline_tot"
    t.float   "vitamin_b12"
    t.integer "vitamin_a_iu"
    t.float   "vitamin_a_rae"
    t.float   "retinol"
    t.float   "alpha_carotnie"
    t.float   "beta_carotine"
    t.float   "beta_crypt"
    t.float   "lycopene"
    t.float   "lut_zea"
    t.float   "vitamin_e"
    t.float   "vitamin_d_mcg"
    t.float   "vi_vitamin_d_iu"
    t.float   "vitamin_k"
    t.float   "saturated_fat"
    t.float   "monounsaturated_fat"
    t.float   "polyunsaturated_fat"
    t.integer "cholesterol"
    t.float   "weight_1"
    t.string  "weight_1_description", :limit => 240
    t.float   "weight_2"
    t.string  "weight_2_description", :limit => 240
    t.integer "refuse_percent"
  end

  add_index "abbreviated_data", ["ndb_no"], :name => "index_abbreviated_data_on_ndb_no"

  create_table "aliases", :id => false, :force => true do |t|
    t.string  "alias"
    t.integer "ndb_no"
  end

  add_index "aliases", ["alias"], :name => "alias"

  create_table "data_src", :id => false, :force => true do |t|
    t.string "data_src_id", :limit => 12
    t.string "authors",     :limit => 510
    t.string "title",       :limit => 510
    t.string "year",        :limit => 8
    t.string "journal",     :limit => 270
    t.string "vol_city",    :limit => 32
    t.string "issue_state", :limit => 10
    t.string "start_page",  :limit => 10
    t.string "end_page",    :limit => 10
  end

  create_table "datsrcln", :id => false, :force => true do |t|
    t.integer "ndb_no"
    t.integer "nutr_no"
    t.string  "data_src_id", :limit => 12
  end

  create_table "deriv_cd", :id => false, :force => true do |t|
    t.string "deriv_cd",   :limit => 8
    t.string "deriv_desc", :limit => 240
  end

  create_table "fd_group", :id => false, :force => true do |t|
    t.string "fd_grp_cd",   :limit => 8
    t.string "fd_grp_desc", :limit => 120
  end

  create_table "food_des", :id => false, :force => true do |t|
    t.integer "ndb_no"
    t.string  "fd_grp_cd",         :limit => 8
    t.string  "long_desc",         :limit => 400
    t.string  "short_description", :limit => 120
    t.string  "com_name",          :limit => 200
    t.string  "manufac_name",      :limit => 130
    t.string  "survey",            :limit => 2
    t.string  "ref_desc",          :limit => 270
    t.integer "refuse"
    t.string  "scientific_name",   :limit => 130
    t.float   "n_factor"
    t.float   "pro_factor"
    t.float   "fat_factor"
    t.float   "cho_factor"
  end

  add_index "food_des", ["ndb_no"], :name => "index_food_des_on_ndb_no"

  create_table "footnotes", :id => false, :force => true do |t|
    t.integer "ndb_no"
    t.string  "footnt_no",   :limit => 8
    t.string  "footnot_typ", :limit => 2
    t.integer "nutr_no"
    t.string  "footnot_txt", :limit => 400
  end

  add_index "footnotes", ["ndb_no"], :name => "index_footnotes_on_ndb_no"

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

  create_table "nutrition_data", :id => false, :force => true do |t|
    t.integer "ndb_no"
    t.integer "nutr_no"
    t.float   "nutrition_value"
    t.integer "num_data_pts"
    t.float   "std_error"
    t.string  "src_cd",          :limit => 4
    t.string  "deriv_cd",        :limit => 8
    t.integer "Ref_ndb_no"
    t.string  "add_nutr_mark",   :limit => 2
    t.integer "num_studies"
    t.float   "min"
    t.float   "max"
    t.float   "df"
    t.float   "low_eb"
    t.float   "up_eb"
    t.string  "stat_cmt",        :limit => 20
  end

  add_index "nutrition_data", ["ndb_no"], :name => "index_nutrition_data_on_ndb_no"

  create_table "nutrition_definitions", :id => false, :force => true do |t|
    t.integer "nutr_no"
    t.string  "units",     :limit => 14
    t.string  "tagname",   :limit => 40
    t.string  "nutr_desc", :limit => 120
    t.string  "num_dec",   :limit => 2
    t.float   "sr_order"
  end

  add_index "nutrition_definitions", ["nutr_no"], :name => "nutr_no"

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

  create_table "src_cd", :id => false, :force => true do |t|
    t.string "src_cd",      :limit => 4
    t.string "src_cd_desc", :limit => 120
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

  create_table "weights", :id => false, :force => true do |t|
    t.integer "ndb_no"
    t.string  "seq",          :limit => 4
    t.float   "amount"
    t.string  "msre_desc",    :limit => 160
    t.float   "gm_wgt"
    t.integer "num_data_pts"
    t.float   "std_dev"
  end

  add_index "weights", ["ndb_no"], :name => "index_weights_on_ndb_no"

end
