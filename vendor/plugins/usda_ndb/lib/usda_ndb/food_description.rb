class UsdaNdb::FoodDescription < ActiveRecord::Base
  establish_connection(UsdaNdb::configurations[Rails.env])
  set_primary_key :ndb_no
end