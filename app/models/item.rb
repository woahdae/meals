class Item < ActiveRecord::Base
  
  belongs_to :recipe
  belongs_to :uid, :class_name => "ItemUID", :foreign_key => "item_uid_id"
  has_many :receipt_items, :primary_key => "item_uid_id", :foreign_key => "item_uid_id"

  validates_presence_of :name
  validates_presence_of :qty
  
  def validate
    begin
      errors.add(:qty, "must contain a unit (ex. #{qty} lbs)") if qty.to_unit.units.blank?
    rescue => e
      if e.message.include?("Unit not recognized")
        errors.add(:qty, "'#{qty}' is not a valid unit")
      else
        raise
      end
    end
  end

  def average_price_per_base_unit
    return nil if receipt_items.empty?
    
    receipt_items.collect(&:price_per_base_unit).sum / receipt_items.size
  end
  
  def average_price_per_amount
    return nil if average_price_per_base_unit.nil?
    
    average_price_per_base_unit.convert_to("USD/#{self.qty.to_unit.units}")
  end
  
  def average_price
    return nil if average_price_per_base_unit.nil? || qty.blank?

    qty.to_unit.to_base * average_price_per_base_unit
  end
  
  def measure(nutrient)
    uid.try(:measure, nutrient, qty)
  end
end









