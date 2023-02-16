require_relative 'DoNothing'

module SmallStep
  class Sequence < Struct.new(:first, :second)
    include SmallStep
    def to_s
      "#{first}; #{second}"
    end

    def inspect
      "<<#{self}>>"
    end

    def reducible?
      true
    end

    def reduce(environment)
      if first == DoNothing.new
        [second, environment]
      else
        first_reduced, env = first.reduce(environment)
        [Sequence.new(first_reduced, second), env]
      end
    end
  end
end
