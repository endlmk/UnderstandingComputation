module Denotational
  class DoNothing
    def to_s
      'do-nothing'
    end

    def inspect
      "<<#{self}>>"
    end

    def to_ruby
      '-> e { e }'
    end
  end
end
