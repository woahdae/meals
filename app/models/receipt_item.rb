class ReceiptItem < ActiveRecord::Base
  belongs_to :uid, :class_name => "ItemUID", :foreign_key => "item_uid_id"
  belongs_to :receipt
  
  validates_presence_of :name, :price, :qty

  def validate
    begin
      qty.to_unit
    rescue => e
      if e.message.include?("Unit not recognized")
        errors.add(:qty, "'#{qty}' is not a valid unit")
      else
        raise
      end
    end
  end
  
  def price_per_base_unit
    self.price.to_unit('dollar') / self.qty.to_unit.to_base
  end
end
