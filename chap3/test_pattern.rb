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
  def test_文字列でマッチングできる
    assert_equal(false, Empty.new.matches?('a'))
    assert_equal(true, Literal.new('a').matches?('a'))
  end
end

class EmptyTest < MiniTest::Test
  def test_空文字を受理する
    nfa_design = Empty.new.to_nfa_design
    assert_equal(true, nfa_design.accepts?(''))
    assert_equal(false, nfa_design.accepts?('a'))
  end
end

class LiteralTest < MiniTest::Test
  def test_指定した文字を受理する
    nfa_design = Literal.new('a').to_nfa_design
    assert_equal(false, nfa_design.accepts?(''))
    assert_equal(true, nfa_design.accepts?('a'))
    assert_equal(false, nfa_design.accepts?('b'))
  end
end
