require_relative('Pattern')

class Repeat < Struct.new(:pattern)
  include Pattern

  def to_s
    pattern.bracket(precedence) + '*'
  end

  def precedence
    2
  end

  def to_nfa_design
    nfa_design = pattern.to_nfa_design
    accept_states = nfa_design.accept_states.append(nfa_design.current_state)
    extra_rules = nfa_design.accept_states.map { |s| FARule.new(s, nil, nfa_design.current_state) }
    rules = nfa_design.rulebook.rules + extra_rules
    NFADesign.new(nfa_design.current_state, accept_states, NFARulebook.new(rules))
  end
end
