require_relative 'NFARulebook'

NFA = Struct.new(:current_states, :accept_states, :rulebook) do
  def accepting?
    (current_states & accept_states).any?
  end

  def read_character(char)
    self.current_states = rulebook.next_states(current_states, char)
  end

  def read_string(str)
    str.chars.each { |c| read_character(c) }
  end
end
