require_relative 'Boolean'

module BigStep
  class If < Struct.new(:condition, :consequence, :alternative)
    include BigStep
    def to_s
      "if (#{condition}) { #{consequence} } else { #{alternative} }"
    end

    def inspect
      "<<#{self}>>"
    end

    def evaluate(environment)
      case condition.evaluate(environment)
      when Boolean.new(true)
        consequence.evaluate(environment)
      when Boolean.new(false)
        alternative.evaluate(environment)
      end
    end
  end
end
