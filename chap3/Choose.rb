require_relative('Pattern')

class Choose < Struct.new(:first, :second)
  include Pattern

  def to_s
    [first, second].map { |pattern| pattern.bracket(precedence) }.join('|')
  end

  def precedence
    0
  end

  def to_nfa_design
    first_nfa_design = first.to_nfa_design
    second_nfa_desgin = second.to_nfa_design

    start = Object.new
    accept_states = merge_accept_states(first_nfa_design, second_nfa_desgin)
    extra_rules = connect_starts_by_free_move(first_nfa_design, second_nfa_desgin, start)
    rules = first_nfa_design.rulebook.rules + second_nfa_desgin.rulebook.rules + extra_rules

    NFADesign.new(start,  accept_states, NFARulebook.new(rules))
  end

  def merge_accept_states(first, second)
    first.accept_states + second.accept_states
  end

  def connect_starts_by_free_move(first, second, start)
    [FARule.new(start, nil, first.current_state), FARule.new(start, nil, second.current_state)]
  end
end
