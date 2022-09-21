require_relative('FARule')

class DFARulebook < Struct.new(:rules)
  def next_state(state, charactor)
    rule_for(state, charactor).follow
  end

  def rule_for(state, charactor)
    rules.detect { |rule| rule.applies_to?(state, charactor) }
  end
end
