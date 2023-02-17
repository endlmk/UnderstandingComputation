module BigStep
  class DoNothing
    def to_s
      'do-nothing'
    end

    def inspect
      "<<#{self}>>"
    end

    def evaluate(environment)
      environment
    end
  end
end
