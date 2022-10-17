require_relative 'FARule'
require 'set'

class NFARulebook < Struct.new(:rules)
  def next_states(states, char)
    states.flat_map { |state| rules_for(state, char) }.to_set
  end

  def rules_for(state, character)
    rules.filter_map { |r| r.next_state if r.state == state && r.character == character }
  end

  def follow_free_move(states)
    free_move_states = next_states(states, nil)
    if free_move_states.subset?(states)
      states
    else
      follow_free_move(states | free_move_states)
    end
  end

  def alphabet
    rules.map(&:character).compact.uniq
  end
end
