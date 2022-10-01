require_relative('Pattern')

class Concatenate < Struct.new(:first, :second)
  include Pattern

  def to_s
    [first, second].map { |pattern| pattern.bracket(precedence) }.join
  end

  def precedence
    1
  end

  def to_nfa_design
    first_nfa_design = first.to_nfa_design
    second_nfa_design = second.to_nfa_design

    extra_rules = create_connect_rules(first_nfa_design, second_nfa_design)
    rules = first_nfa_design.rulebook.rules + second_nfa_design.rulebook.rules + extra_rules

    NFADesign.new(first_nfa_design.start_state, second_nfa_design.accept_states, NFARulebook.new(rules))
  end

  def create_connect_rules(first_nfa_design, second_nfa_design)
    first_nfa_design.accept_states.map { |s| FARule.new(s, nil, second_nfa_design.start_state) }
  end
end
