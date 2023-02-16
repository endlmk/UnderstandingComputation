module BigStep
  class Assign < Struct.new(:name, :expression)
    include BigStep
    def to_s
      "#{name} = #{expression}"
    end

    def inspect
      "<<#{self}>>"
    end

    def evaluate(environment)
      environment.merge({ name => expression.evaluate(environment) })
    end
  end
end
