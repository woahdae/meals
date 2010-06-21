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
      unit.send(operation, copy(other).convert_to(unit))
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
