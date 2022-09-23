require_relative 'FARule'
require 'set'

class NFARulebook < Struct.new(:rules)
  def next_states(states, char)
    states.flat_map do |s|
      rules.filter do |r|
        r.state == s && r.character == char
      end.map(&:next_state)
    end.to_set
  end
end
