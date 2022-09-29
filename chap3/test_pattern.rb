require('minitest/autorun')
require_relative('Empty')
require_relative('Literal')
require_relative('Concatenate')
require_relative('Choose')
require_relative('Repeat')

class PatternTest < MiniTest::Test
  def test_パターンを構築できる
    pattern = Repeat.new(
      Choose.new(
        Concatenate.new(Literal.new('a'), Literal.new('b')),
        Literal.new('a')
      )
    )
    assert_equal('/(ab|a)*/', pattern.inspect)
  end
end

class EmptyTest < MiniTest::Test
  def test_空文字を受理する
    nfa_design = Empty.new.to_nfa_design
    assert_equal(true, nfa_design.accepts?(''))
    assert_equal(false, nfa_design.accepts?('a'))
  end

  def test_空文字にマッチする
    assert_equal(true, Empty.new.matches?(''))
    assert_equal(false, Empty.new.matches?('a'))
  end
end

class LiteralTest < MiniTest::Test
  def test_指定した文字を受理する
    nfa_design = Literal.new('a').to_nfa_design
    assert_equal(false, nfa_design.accepts?(''))
    assert_equal(true, nfa_design.accepts?('a'))
    assert_equal(false, nfa_design.accepts?('b'))
  end

  def test_指定文字にマッチする
    assert_equal(true, Literal.new('a').matches?('a'))
    assert_equal(false, Literal.new('a').matches?('b'))
  end
end

class ConcatenateTest < MiniTest::Test
  def test_二つのLiteralを連結できる
    pattern = Concatenate.new(Literal.new('a'), Literal.new('b'))
    assert_equal(false, pattern.matches?('a'))
    assert_equal(true, pattern.matches?('ab'))
  end

  def test_三つのLiteralを連結できる
    pattern = Concatenate.new(
      Literal.new('a'),
      Concatenate.new(Literal.new('b'), Literal.new('c'))
    )
    assert_equal(false, pattern.matches?('a'))
    assert_equal(false, pattern.matches?('ab'))
    assert_equal(true, pattern.matches?('abc'))
    assert_equal(false, pattern.matches?('abcd'))
  end
end

class ChooseTest < MiniTest::Test
  def test_二つのLiteralのいずれかにマッチする
    pattern = Choose.new(Literal.new('a'), Literal.new('b'))
    assert_equal(true, pattern.matches?('a'))
    assert_equal(true, pattern.matches?('b'))
    assert_equal(false, pattern.matches?('c'))
    assert_equal(false, pattern.matches?('ab'))
  end
end

class RepeatTest < MiniTest::Test
  def test_0回以上の繰り返しにマッチする
    pattern = Repeat.new(Literal.new('a'))
    assert_equal(true, pattern.matches?(''))
    assert_equal(true, pattern.matches?('a'))
    assert_equal(true, pattern.matches?('aa'))
    assert_equal(true, pattern.matches?('aaa'))
    assert_equal(true, pattern.matches?('aaaaaa'))
    assert_equal(false, pattern.matches?('b'))
    assert_equal(false, pattern.matches?('aba'))
  end
end
