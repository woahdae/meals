class Store < ActiveRecord::Base
  has_many :receipts
  belongs_to :chain
end
