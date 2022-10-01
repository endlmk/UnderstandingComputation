require_relative 'DFADesign'
require_relative 'DFARulebook'

class NFASimulation < Struct.new(:nfa_design)
  def next_state(states, character)
    nfa_design.to_nfa(states).tap do |nfa|
      nfa.read_character(character)
    end.current_states
  end

  def rules_for(states)
    nfa_design.rulebook.alphabet.map do |c|
      FARule.new(states, c, next_state(states, c))
    end
  end

  def discover_states_and_rules(states)
    rules = states.flat_map { |s| rules_for(s) }
    more_states = rules.map(&:follow).to_set

    if more_states.subset?(states)
      [states, rules]
    else
      discover_states_and_rules(more_states)
    end
  end

  def to_dfa_design
    start_state = nfa_design.to_nfa.current_states
    states, rules = discover_states_and_rules(Set[start_state])
    accept_states = states.filter { |state| nfa_design.to_nfa(state).accepting? }
    DFADesign.new(start_state, accept_states, DFARulebook.new(rules))
  end
end
