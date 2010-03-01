class Food < ActiveRecord::Base
  has_one :item_uid, :class_name => "ItemUID"
  
  after_create { |food| ItemUID.create(:food => food) }
  after_update { |food| FerretItemUID.update(food.item_uid) }

end
