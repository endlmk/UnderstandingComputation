class PDARule < Struct.new(:state, :character, :next_state, :pop_character, :push_characters)
  def applies_to?(config, next_charcter)
    state == config.state && character == next_charcter && pop_character == config.stack.top
  end
end
