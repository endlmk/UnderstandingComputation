require_relative('Pattern')

class Literal < Struct.new(:character)
  include Pattern

  def to_s
    character
  end

  def precedence
    3
  end

  def to_nfa_design
    start_state = Object.new
    accept_state = Object.new
    NFADesign.new(start_state, [accept_state],
                  NFARulebook.new([FARule.new(start_state, character, accept_state)]))
  end
end
