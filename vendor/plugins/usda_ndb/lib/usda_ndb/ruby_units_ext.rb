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

  alias :orig_round :round
  def round(val = nil)
    if val
      scalar.round(val).to_unit(units)
    else
      orig_round
    end
  end
end