class PDARule < Struct.new(:state, :character, :next_state, :pop_character, :push_characters)
  def applies_to?(config, next_charcter)
    state == config.state && character == next_charcter && pop_character == config.stack.top
  end

  def follow(configuration)
    PDAConfiguration.new(next_state, next_stack(configuration))
  end

  def next_stack(configuration)
    stack = configuration.stack.pop
    push_characters.reverse_each { |c| stack.push(c) }
    stack
  end
end
