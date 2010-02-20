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

ActiveRecord::Schema.define(:version => 0) do

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

  add_index "abbreviated_data", ["ndb_no"]

  create_table "aliases", :id => false, :force => true do |t|
    t.string  "alias"
    t.integer "ndb_no"
  end

  add_index "aliases", ["alias"]

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

  create_table "food_descriptions", :id => false, :force => true do |t|
    t.integer "ndb_no"
    t.string  "food_group_code",     :limit => 8
    t.string  "long_description",    :limit => 400
    t.string  "short_description",   :limit => 120
    t.string  "common_names",        :limit => 200
    t.string  "manufacturer_name",   :limit => 130
    t.string  "survey",              :limit => 2
    t.string  "refuse_description",  :limit => 270
    t.integer "refuse"
    t.string  "scientific_name",     :limit => 130
    t.float   "nitrogen_factor"
    t.float   "protein_factor"
    t.float   "fat_factor"
    t.float   "carbohydrate_factor"
  end

  add_index "food_descriptions", ["ndb_no"]

  create_table "food_group", :id => false, :force => true do |t|
    t.string "food_group_code",        :limit => 8
    t.string "food_group_description", :limit => 120
  end

  create_table "footnotes", :id => false, :force => true do |t|
    t.integer "ndb_no"
    t.string  "footnt_no",   :limit => 8
    t.string  "footnot_typ", :limit => 2
    t.integer "nutr_no"
    t.string  "footnot_txt", :limit => 400
  end

  add_index "footnotes", ["ndb_no"]

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

  add_index "nutrition_data", ["ndb_no"]

  create_table "nutrition_definitions", :id => false, :force => true do |t|
    t.integer "nutr_no"
    t.string  "units",     :limit => 14
    t.string  "tagname",   :limit => 40
    t.string  "nutr_desc", :limit => 120
    t.string  "num_dec",   :limit => 2
    t.float   "sr_order"
  end

  add_index "nutrition_definitions", ["nutr_no"]

  create_table "src_cd", :id => false, :force => true do |t|
    t.string "src_cd",      :limit => 4
    t.string "src_cd_desc", :limit => 120
  end

  create_table "weights", :id => false, :force => true do |t|
    t.integer "ndb_no"
    t.string  "seq",          :limit => 4
    t.float   "amount"
    t.string  "msre_desc",    :limit => 160
    t.float   "gm_wgt"
    t.integer "num_data_pts"
    t.float   "std_dev"
  end

  add_index "weights", ["ndb_no"]

end
