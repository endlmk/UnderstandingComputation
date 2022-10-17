class DPDA < Struct.new(:current_configuration, :accept_states, :rulebook)
  STUCK_STATE = Object.new
  def accepting?
    accept_states.include?(current_configuration.state)
  end

  def read_string(str)
    str.chars.each { |character| read_character(character) }
  end

  def read_character(character)
    self.current_configuration =
      if rulebook.applies_to?(current_configuration, character)
        rulebook.next_configuration(current_configuration, character)
      else
        current_configuration.stuck
      end
  end

  def current_configuration
    rulebook.follow_free_moves(super)
  end

  def stuck?
    current_configuration.stuck?
  end
end
