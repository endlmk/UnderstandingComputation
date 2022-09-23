require "minitest/autorun"
require_relative 'FARule'
require_relative 'DFARulebook'
require_relative 'DFA'
require_relative 'DFADesign'

class TestFARules < Minitest::Test
  def test_FARuleを作れる
    rule = FARule.new(1, 'a', 2)
    assert(rule)
    assert_equal(1, rule.state)
    assert_equal('a', rule.character)
    assert_equal(2, rule.next_state)
  end

  def test_FARuleが適用されるか判定できる
    rule = FARule.new(1, 'a', 2)
    assert_equal(true, rule.applies_to?(1, 'a'))
    assert_equal(false, rule.applies_to?(1, 'b'))
    assert_equal(false, rule.applies_to?(2, 'a'))
  end
end

class TestDFARuleBook < MiniTest::Test
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

class TestDFA < MiniTest::Test
  def setup
    @rulebook = DFARulebook.new(
      [
        FARule.new(1, 'a', 2), FARule.new(1, 'b', 1),
        FARule.new(2, 'a', 2), FARule.new(2, 'b', 3),
        FARule.new(3, 'a', 3), FARule.new(3, 'b', 3)
      ]
    )
  end

  def test_DFAの受理状態を判定できる
    assert_equal(true, DFA.new(1, [1, 3], @rulebook).accepting?)
    assert_equal(false, DFA.new(1, [3], @rulebook).accepting?)
  end

  def test_DFAに文字を与えて状態が変わる
    dfa = DFA.new(1, [3], @rulebook)
    assert_equal(false, dfa.accepting?)

    dfa.read_character('b')
    assert_equal(false, dfa.accepting?)

    3.times do dfa.read_character('a') end
    assert_equal(false, dfa.accepting?)

    dfa.read_character('b')
    assert_equal(true, dfa.accepting?)
  end

  def test_DFAに文字列を与えられる
    dfa = DFA.new(1, [3], @rulebook)
    dfa.read_string('baaab')
    assert_equal(true, dfa.accepting?)
  end
end


class TestDFADesign < MiniTest::Test
  def setup
    @rulebook = DFARulebook.new(
      [
        FARule.new(1, 'a', 2), FARule.new(1, 'b', 1),
        FARule.new(2, 'a', 2), FARule.new(2, 'b', 3),
        FARule.new(3, 'a', 3), FARule.new(3, 'b', 3)
      ]
    )
  end

  def test_DFADesignで初期状態から入力を与えられる
    dfa_design = DFADesign.new(1, [3], @rulebook)

    assert_equal(false, dfa_design.accepts?('a'))
    assert_equal(false, dfa_design.accepts?('baa'))
    assert_equal(true, dfa_design.accepts?('baba'))
  end
end
