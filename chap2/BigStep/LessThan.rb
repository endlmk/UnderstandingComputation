require_relative 'Boolean'

module BigStep
  class LessThan < Struct.new(:left, :right)
    def to_s
      "#{left} < #{right}"
    end

    def inspect
      "<<#{self}>>"
    end

    def evaluate(environment)
      Boolean.new(left.evaluate(environment).value < right.evaluate(environment).value)
    end
  end
end
