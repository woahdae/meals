class Chain < ActiveRecord::Base
  has_many :stores
  
  validates_uniqueness_of :name, :on => :create, :message => "already exists"
end
