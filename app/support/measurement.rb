class Measurement
  attr_accessor :items, :missing, :value

  def initialize(value = nil)
    @value = value
    @items, @missing = {}, []
  end

  def items_with_missing
    items.sort {|a, b| b.last <=> a.last} + missing.map {|m| [m.name, "?"]}
  end

  def approximate?
    @missing.any?
  end

  def ==(other)
    value == other
  end

  def to_s
    if @value.is_a?(Unit) && @value.units == "USD"
      if approximate?
        "~$#{value.scalar.to_f.round(2)}"
      else
        "$#{value.scalar.to_f.round(2)}"
      end
    elsif approximate?
      "~#{value.round}"
    else
      value.round.to_s
    end
  end

  def to_f
    value.scalar.to_f
  end

  def method_missing(method, *args, &block)
    value.send(method, *args, &block)
  end
end