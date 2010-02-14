class Receipt < ActiveRecord::Base
  has_many :items, :class_name => "ReceiptItem", :dependent => :destroy
  belongs_to :store
  belongs_to :user
  accepts_nested_attributes_for :items, :reject_if => Proc.new { |attributes| attributes['name'].blank? }
  
  def name
    "#{store.name} #{created_at.strftime("%m/%d/%Y")}"
  end
end
