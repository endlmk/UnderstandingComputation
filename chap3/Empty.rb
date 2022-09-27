require_relative('Pattern')
require_relative('NFADesign')

class Empty
  include Pattern

  def to_s
    ''
  end

  def precedence
    3
  end

  def to_nfa_design
    start_state = Object.new
    NFADesign.new(start_state, [start_state], NFARulebook.new([]))
  end
end
