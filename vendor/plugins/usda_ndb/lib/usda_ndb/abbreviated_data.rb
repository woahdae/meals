class UsdaNdb::AbbreviatedData < ActiveRecord::Base
  establish_connection(UsdaNdb::configurations[Rails.env])
  set_primary_key :ndb_no
  set_table_name :abbreviated_data
end