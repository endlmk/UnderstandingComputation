require "minitest/autorun"
require_relative 'FARule'
require_relative 'NFARulebook'
require 'set'

class NFARulebookTest < MiniTest::Test
  def setup
    @rulebook = NFARulebook.new(
      [
        FARule.new(1, 'a', 1), FARule.new(1, 'b', 1), FARule.new(1, 'b', 2),
        FARule.new(2, 'a', 3), FARule.new(2, 'b', 3),
        FARule.new(3, 'a', 4), FARule.new(3, 'b', 4)
      ]
    )
  end

  def test_状態遷移できる
    assert_equal(Set[1, 2], @rulebook.next_states(Set[1], 'b'))
    assert_equal(Set[1, 3], @rulebook.next_states(Set[1, 2], 'a'))
    assert_equal(Set[1, 2, 4], @rulebook.next_states(Set[1, 3], 'b'))
  end
end
