module SmallStep
  class If < Struct.new(:condition, :consequence, :alternative)
    include SmallStep
    def to_s
      "if (#{condition}) { #{consequence} } else { #{alternative} }"
    end

    def inspect
      "<<#{self}>>"
    end

    def reducible?
      true
    end

    def reduce(environment)
      if condition.reducible?
        If.new(condition.reduce(environment), consequence, alternative)
      else
        case condition
        when Boolean.new(true)
          [consequence, environment]
        when Boolean.new(false)
          [alternative, environment]
        end
      end
    end
  end
end
