require "minitest/autorun"
require_relative 'FARule'
require_relative 'DFARulebook'

class TestFARules < Minitest::Test
  def test_FARuleを作れる
    rule = FARule.new(1, 'a', 2)
    assert(rule)
    assert_equal(1, rule.state)
    assert_equal('a', rule.charactor)
    assert_equal(2, rule.next_state)
  end

  def test_FARuleが適用されるか判定できる
    rule = FARule.new(1, 'a', 2)
    assert_equal(true, rule.applies_to?(1, 'a'))
    assert_equal(false, rule.applies_to?(1, 'b'))
    assert_equal(false, rule.applies_to?(2, 'a'))
  end
end

class TestDFA < MiniTest::Test
  def test_DFARulebookで状態遷移できる
    rulebook = DFARulebook.new(
      [
        FARule.new(1, 'a', 2), FARule.new(1, 'b', 1),
        FARule.new(2, 'a', 2), FARule.new(2, 'b', 3),
        FARule.new(3, 'a', 3), FARule.new(3, 'b', 3)
      ]
    )
    assert_equal(2, rulebook.next_state(1, 'a'))
    assert_equal(1, rulebook.next_state(1, 'b'))
    assert_equal(3, rulebook.next_state(2, 'b'))
  end
end
