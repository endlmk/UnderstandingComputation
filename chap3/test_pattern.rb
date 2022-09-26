require('minitest/autorun')
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
