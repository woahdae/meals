class Item < ActiveRecord::Base
  belongs_to :recipe
  acts_as_unitable :bulk_qty, :amount
end
