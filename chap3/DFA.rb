require_relative 'DFARulebook'

DFA = Struct.new(:current_state, :accept_states, :rulebook) do
  def accepting?
    accept_states.include?(current_state)
  end

  def read_character(char)
    self.current_state = rulebook.next_state(current_state, char)
  end

  def read_string(str)
    str.chars.each do |char|
      read_character(char)
    end
  end
end
