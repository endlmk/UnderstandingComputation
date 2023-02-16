module SmallStep
  class Number < Struct.new(:value)
    include SmallStep
    def to_s
      value.to_s
    end

    def inspect
      "<<#{self}>>"
    end

    def reducible?
      false
    end
  end
end
