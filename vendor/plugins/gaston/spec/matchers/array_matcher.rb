class ArrayMatcher

  def initialize(array_to_match)
    @array_to_match = array_to_match
  end

  def ==(other)
    @array_to_match.inject(true) do |result, item|
      result && other.include?(item)
    end
  end
end

def array_including(arr)
  ArrayMatcher.new(arr)
end
