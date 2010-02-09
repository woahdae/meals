data = File.read('usda_ndb_orig.sql')

{
  "ABBREV"             => "abbreviated_data",
  "Add_Nutr_Mark"      => "add_nutr_mark",
  "Alias"              => "alias",
  "ALIASES"            => "aliases",
  "Alpha_Carot"        => "alpha_carotnie",
  "Amount"             => "amount",
  "Ash"                => "ash",
  "Authors"            => "authors",
  "Beta_Carot"         => "beta_carotine",
  "Beta_Crypt"         => "beta_crypt",
  "Calcium"            => "calcium",
  "Carbohydrt"         => "carbs",
  "Cholestrl"          => "cholesterol",
  "Choline_Tot"        => "choline_tot",
  "CHO_Factor"         => "cho_factor",
  "ComName"            => "com_name",
  "Copper"             => "copper",
  "DataSrc_ID"         => "data_src_id",
  "DATA_SRC"           => "data_src",
  "DATSRCLN"           => "datsrcln",
  "DERIV_CD"           => "deriv_cd",
  "Deriv_CD"           => "deriv_cd",
  "Deriv_Cd"           => "deriv_cd",
  "Deriv_Desc"         => "deriv_desc",
  "DF"                 => "df",
  "End_Page"           => "end_page",
  "Energ_Kcal"         => "kcal",
  "Fat_Factor"         => "fat_factor",
  "FA_Mono"            => "monounsaturated_fat",
  "FA_Poly"            => "polyunsaturated_fat",
  "FA_Sat"             => "saturated_fat",
  "FdGrp_CD"           => "fd_grp_cd",
  "FdGrp_Cd"           => "fd_grp_cd",
  "FdGrp_Desc"         => "fd_grp_desc",
  "FD_GROUP"           => "fd_group",
  "Fiber_TD"           => "fiber",
  "Folate_DFE"         => "folate_dfe",
  "Folate_Tot"         => "folate_total",
  "Folic_Acid"         => "folic_acid",
  "FOOD_DES"           => "food_des",
  "Food_Folate"        => "food_folate",
  "FOOTNOTE"           => "footnotes",
  "Footnot_Txt"        => "footnot_txt",
  "Footnot_Typ"        => "footnot_typ",
  "Footnt_No"          => "footnt_no",
  "GmWt_1"             => "weight_1",
  "GmWt_2"             => "weight_2",
  "GmWt_Desc1"         => "weight_1_description",
  "GmWt_Desc2"         => "weight_2_description",
  "Gm_Wgt"             => "gm_wgt",
  "Iron"               => "iron",
  "Issue_State"        => "issue_state",
  "Journal"            => "journal",
  "Lipid_Tot"          => "fat",
  "Long_Desc"          => "long_desc",
  "Low_EB"             => "low_eb",
  "Lut_Zea"            => "lut_zea",
  "Lycopene"           => "lycopene",
  "Magnesium"          => "magnesium",
  "Manganese"          => "manganese",
  "ManufacName"        => "manufac_name",
  "Max"                => "max",
  "Min"                => "min",
  "Msre_Desc"          => "msre_desc",
  "NDB_NO"             => "ndb_no",
  "NDB_No"             => "ndb_no",
  "Niacin"             => "niacin",
  "Num_Data_Pts"       => "num_data_pts",
  "Num_Dec"            => "num_dec",
  "Num_Studies"        => "num_studies",
  "NutrDesc"           => "nutr_desc",
  "NUTR_DEF"           => "nutrition_definitions",
  "Nutr_No"            => "nutr_no",
  "Nutr_Val"           => "nutrition_value",
  "NUT_DATA"           => "nutrition_data",
  "N_Factor"           => "n_factor",
  "Panto_Acid"         => "pantothenic_acid",
  "Phosphorus"         => "phosphorus",
  "Potassium"          => "potassium",
  "Protein"            => "protein",
  "Pro_Factor"         => "pro_factor",
  "Refuse"             => "refuse",
  "Refuse_Pct"         => "refuse_percent",
  "Ref_Desc"           => "ref_desc",
  "Ref_NDB_No"         => "ref_ndb_no",
  "Retinol"            => "retinol",
  "Riboflavin"         => "riboflavin",
  "SciName"            => "scientific_name",
  "Selenium"           => "selenium",
  "Seq"                => "seq",
  "Shrt_Desc"          => "short_description",
  "Sodium"             => "sodium",
  "SrcCd_Desc"         => "src_cd_desc",
  "SRC_CD"             => "src_cd",
  "Src_Cd"             => "src_cd",
  "SR_Order"           => "sr_order",
  "Start_Page"         => "start_page",
  "Stat_Cmt"           => "stat_cmt",
  "Std_Dev"            => "std_dev",
  "Std_Error"          => "std_error",
  "Sugar_Tot"          => "sugar",
  "Survey"             => "survey",
  "Tagname"            => "tagname",
  "Thiamin"            => "thiamin",
  "Title"              => "title",
  "Units"              => "units",
  "Up_EB"              => "up_eb",
  "Vit_A_IU"           => "vitamin_a_iu",
  "Vit_A_RAE"          => "vitamin_a_rae",
  "Vit_B12"            => "vitamin_b12",
  "Vit_B6"             => "vitamin_b6",
  "Vit_C"              => "vitamin_c",
  "Vit_D_mcg"          => "vitamin_d_mcg",
  "Vit_E"              => "vitamin_e",
  "Vit_K"              => "vitamin_k",
  "ViVit_D_IU"         => "vi_vitamin_d_iu",
  "Vol_City"           => "vol_city",
  "Water"              => "water",
  "WEIGHT"             => "weights",
  "Year"               => "year",
  "Zinc"               => "zinc"
}.each {|(k, v)| data.gsub!(k, v)}

File.open('usda_ndb.sql', "w") {|file| file << data}