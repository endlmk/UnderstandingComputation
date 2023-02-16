module BigStep
  class While < Struct.new(:condition, :body)
    include BigStep
    def to_s
      "while (#{condition}) { #{body} }"
    end

    def inspect
      "<<#{self}>>"
    end

    def evaluate(environment)
      case condition.evaluate(environment)
      when Boolean.new(true)
        evaluate(body.evaluate(environment))
      when Boolean.new(false)
        environment
      end
    end
  end
end
