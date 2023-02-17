require_relative 'If'
require_relative 'Sequence'
require_relative 'DoNothing'

module SmallStep
  class While < Struct.new(:condition, :body)
    def to_s
      "while (#{condition}) { #{body} }"
    end

    def inspect
      "<<#{self}>>"
    end

    def reducible?
      true
    end

    def reduce(environment)
      [If.new(condition,
              Sequence.new(body, While.new(condition, body)),
              DoNothing.new),
       environment]
    end
  end
end
