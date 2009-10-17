Factory.define :item do |item|
  item.name "Example Item"
  item.amount 5
  item.amount_unit "pounds"
  item.bulk_price 9.99
  item.bulk_qty 11
  item.bulk_qty_unit "pounds"
  item.calories 1
  item.fat 1.5
  item.carbs 1.5
  item.protein 1.5
  item.recipe_id 1
end

Factory.define :item_using_volume_units, :parent => :item do |item|
  item.bulk_qty(0.00378541) # remember, stores it in base unit
  item.bulk_qty_unit "gallons"
  item.amount 0.00118294
  item.amount_unit "cups"
end