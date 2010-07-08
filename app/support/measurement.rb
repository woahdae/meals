class Measurement
  attr_accessor :missing, :value

  def initialize(value = nil)
    @value = value
    @missing = []
  end

  def approximate?
    @missing.any?
  end

  def ==(other)
    value == other
  end

  def to_s
    if approximate?
      "~#{value.round}"
    else
      value.round.to_s
    end
  end

  def method_missing(method, *args, &block)
    value.send(method, *args, &block)
  end
end