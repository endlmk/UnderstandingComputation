module SmallStep
  class DoNothing
    def to_s
      'do-nothing'
    end

    def inspect
      "<<#{self}>>"
    end

    def ==(other)
      other.instance_of?(DoNothing)
    end

    def reducible?
      false
    end
  end
end
