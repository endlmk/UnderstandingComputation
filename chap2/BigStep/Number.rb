module BigStep
  class Number < Struct.new(:value)
    include BigStep
    def to_s
      value.to_s
    end

    def inspect
      "<<#{self}>>"
    end

    def evaluate(_environment)
      self
    end
  end
end
