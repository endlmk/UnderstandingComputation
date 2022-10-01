require_relative('NFA')

NFADesign = Struct.new(:start_state, :accept_states, :rulebook) do
  def accepts?(str)
    to_nfa.tap { |nfa| nfa.read_string(str) }.accepting?
  end

  def to_nfa(current_states = Set[start_state])
    NFA.new(current_states, accept_states, rulebook)
  end
end
