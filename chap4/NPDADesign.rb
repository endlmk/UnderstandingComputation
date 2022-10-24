require('set')
require_relative('PDAConfiguration')
require_relative('Stack')
require_relative('NPDA')

class NPDADesign < Struct.new(:start_state, :bottom_character, :accept_states, :rulebook)
  def accepts?(str)
    to_npda.tap { |npda| npda.read_string(str) }.accepting?
  end

  def to_npda
    start_stack = Stack.new([bottom_character])
    start_configuration = PDAConfiguration.new(start_state, start_stack)
    NPDA.new(Set[start_configuration], accept_states, rulebook)
  end
end