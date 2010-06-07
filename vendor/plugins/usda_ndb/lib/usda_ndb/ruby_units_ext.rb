# the usda db uses 'tbsp' as a synonym for tablespoon; adding that here
class Unit
  @@USER_DEFINITIONS = {
    '<tablespoon>' => [
      %w{tbs tbsp tablespoon tablespoons},
      1.47867648e-5,
      :volume,
      %w{<meter> <meter> <meter>} ],
    '<international unit>' => [%w{IU}, 1, :pharmacology] }

  Unit.setup
end