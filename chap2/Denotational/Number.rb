module Denotational
  class Number < Struct.new(:value)
    def to_s
      value.to_s
    end

    def inspect
      "<<#{self}>>"
    end

    def to_ruby
      "-> e { #{value} }"
    end
  end
end
