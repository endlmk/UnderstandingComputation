require_relative 'Number'

module BigStep
  class Add < Struct.new(:left, :right)
    def to_s
      "#{left} + #{right}"
    end

    def inspect
      "<<#{self}>>"
    end

    def evaluate(environment)
      Number.new(left.evaluate(environment).value + right.evaluate(environment).value)
    end
  end
end
