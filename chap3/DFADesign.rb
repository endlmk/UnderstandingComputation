require_relative 'DFA'

class DFADesign < Struct.new(:current_state, :accept_states, :rulebook)
  def to_dfa
    DFA.new(current_state, accept_states, rulebook)
  end

  def accepts?(str)
    to_dfa.tap { |dfa| dfa.read_string(str) }.accepting?
  end
end