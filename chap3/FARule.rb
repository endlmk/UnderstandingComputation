class FARule < Struct.new(:state, :charactor, :next_state)
  def applies_to?(state, charactor)
    self.state == state && self.charactor == charactor
  end

  def follow
    next_state
  end

  def inspect
    "#<FARule #{state.inspect} --#{charactor}--> #{next_state.inspect}"
  end
end
