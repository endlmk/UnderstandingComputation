class DPDADesign < Struct.new(:start_state, :bottom_character, :accept_states, :rulebook)
  def accepts?(str)
    dpda = DPDA.new(PDAConfiguration.new(start_state, Stack.new([bottom_character])),
                    accept_states,
                    rulebook)
    dpda.read_string(str)
    dpda.accepting?
  end
end
