require_relative('NFA')

NFADesign = Struct.new(:current_state, :accept_states, :rulebook) do
  def accepts?(str)
    to_nfa.tap { |nfa| nfa.read_string(str) }.accepting?
  end

  def to_nfa
    NFA.new(Set[current_state], accept_states, rulebook)
  end
end
