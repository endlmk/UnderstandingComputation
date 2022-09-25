require "minitest/autorun"
require_relative 'FARule'
require_relative 'NFARulebook'
require 'set'
require_relative 'NFA'
require_relative 'NFADesign'

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

  def test_NFARulebookTestで状態遷移できる
    assert_equal(Set[1, 2], @rulebook.next_states(Set[1], 'b'))
    assert_equal(Set[1, 3], @rulebook.next_states(Set[1, 2], 'a'))
    assert_equal(Set[1, 2, 4], @rulebook.next_states(Set[1, 3], 'b'))
  end
end

class NFATest < MiniTest::Test
  def setup
    @rulebook = NFARulebook.new(
      [
        FARule.new(1, 'a', 1), FARule.new(1, 'b', 1), FARule.new(1, 'b', 2),
        FARule.new(2, 'a', 3), FARule.new(2, 'b', 3),
        FARule.new(3, 'a', 4), FARule.new(3, 'b', 4)
      ]
    )
  end

  def test_NFAの受理状態を判定できる
    assert_equal(false, NFA.new(Set[1], [4], @rulebook).accepting?)
    assert_equal(true, NFA.new(Set[1, 2, 4], [4], @rulebook).accepting?)
  end

  def test_NFAに文字列を与えて状態が変わる
    nfa = NFA.new(Set[1], [4], @rulebook)
    assert_equal(false, nfa.accepting?)

    nfa.read_character('b')
    assert_equal(false, nfa.accepting?)

    nfa.read_character('a')
    assert_equal(false, nfa.accepting?)

    nfa.read_character('b')
    assert_equal(true, nfa.accepting?)
  end

  def test_NFAに文字列を与えられる
    nfa = NFA.new(Set[1], [4], @rulebook)
    assert_equal(false, nfa.accepting?)

    nfa.read_string('bbbbb')
    assert_equal(true, nfa.accepting?)
  end
end

class NFADesignTest < MiniTest::Test
  def setup
    @rulebook = NFARulebook.new(
      [
        FARule.new(1, 'a', 1), FARule.new(1, 'b', 1), FARule.new(1, 'b', 2),
        FARule.new(2, 'a', 3), FARule.new(2, 'b', 3),
        FARule.new(3, 'a', 4), FARule.new(3, 'b', 4)
      ]
    )
  end

  def test_NFADesignで初期状態から入力を与えられる
    nfa_design = NFADesign.new(1, [4], @rulebook)

    assert_equal(true, nfa_design.accepts?('bab'))
    assert_equal(true, nfa_design.accepts?('bbbbb'))
    assert_equal(false, nfa_design.accepts?('bbabb'))
  end
end

class NFARulebookFreeMoveTest < MiniTest::Test
  def setup
    @rulebook = NFARulebook.new(
      [
        FARule.new(1, nil, 2), FARule.new(1, nil, 4),
        FARule.new(2, 'a', 3),
        FARule.new(3, 'a', 2),
        FARule.new(4, 'a', 5),
        FARule.new(5, 'a', 6),
        FARule.new(6, 'a', 4),
      ]
    )
  end

  def test_自由移動できる
    assert_equal(Set[2, 4], @rulebook.next_states(Set[1], nil))
  end

  def test_自由移動で到達可能な状態を特定できる
    assert_equal(Set[1, 2, 4], @rulebook.follow_free_move(Set[1]))
  end

  def test_NFADesignで自由移動に対応できる
    nfa_design = NFADesign.new(1, [2, 4], @rulebook)

    assert_equal(true, nfa_design.accepts?(''))
    assert_equal(false, nfa_design.accepts?('a'))
    assert_equal(true, nfa_design.accepts?('aa'))
    assert_equal(true, nfa_design.accepts?('aaa'))
    assert_equal(false, nfa_design.accepts?('aaaaa'))
    assert_equal(true, nfa_design.accepts?('aaaaaa'))
  end
end
