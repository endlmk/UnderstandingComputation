class TMRule < Struct.new(:state, :character, :next_state, :write_character, :direction)
  def applies_to?(configuration)
    configuration.state == state && configuration.tape.middle == character
  end
end
