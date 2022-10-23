class NPDA < Struct.new(:current_configurations, :accept_states, :rulebook)
  def accepting?
    current_configurations.any? { |config| accept_states.include?(config.state) }
  end

  def read_string(str)
    str.each_char { |c| read_character(c) }
  end

  def read_character(char)
    self.current_configurations = rulebook.next_configurations(current_configurations, char)
  end

  def current_configurations
    rulebook.follow_free_moves(super)
  end
end
