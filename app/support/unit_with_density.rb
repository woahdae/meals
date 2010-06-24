# Developers note: you can get into situations
# where it doesn't make sense to perform operations
# that return a UnitWithDensity, ex. adding 1 cup
# of flower and 1 cup of water would return a UnitWithDensity
# of ~2 cups, but what is the density of flowery water?
# it's not the same as flower or water, which is what it would
# return. It does make sense when adding 1 cup flower plus
# 100 grams flower, which is often the case in this application.
# When I have to do calculations where this is not the case, I'll
# update this behavior. Until then, you (future me) have been warned.
class UnitWithDensity
  attr_reader :density, :unit

  delegate :scalar, :kind, :to_unit, :to => :unit

  def initialize(unit, options = {})
    @unit = unit.to_unit
    @density = options[:density]
  end

  def +(other)
    copy(operate_on_another(:+, other))
  end

  def -(other)
    copy(operate_on_another(:-, other))
  end 

  def abs
    copy(unit.abs)
  end

  def <(other)
    operate_on_another(:<, other)
  end

  def /(other)
    operate_on_another(:/, other)
  end

  def ==(other)
    operate_on_another(:==, other)
  end

  def convert_to(other)
    other = copy(other)
    if unit.compatible?(other.unit)
      unit.convert_to(other.unit)
    else
      if other.kind == :volume
        to_volume.convert_to(other)
      elsif other.kind == :mass
        to_mass.convert_to(other)
      end
    end
  end

  private
    def operate_on_another(operation, other)
      convert_to(other).unit.send(operation, other.unit)
    end

    def to_volume
      copy(unit * density.inverse)
    end

    def to_mass
      copy(unit * density)
    end

    def copy(unit)
      self.class.new(unit, :density => density)
    end
  # /private
end
