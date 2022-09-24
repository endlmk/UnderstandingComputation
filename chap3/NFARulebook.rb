require_relative 'FARule'
require 'set'

class NFARulebook < Struct.new(:rules)
  def next_states(states, char)
    states.flat_map { |state| rules_for(state, char) }.to_set
  end

  def rules_for(state, character)
    rules.filter_map { |r| r.next_state if r.state == state && r.character == character }
  end
end
