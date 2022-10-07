require('minitest/autorun')
require_relative('Stack')

class StackTest < MiniTest::Test
  def setup
    @stack = Stack.new(['a', 'b', 'c', 'd', 'e'])
  end
  def test_topで最上位を取得できる
    assert_equal('a', @stack.top)
  end

  def test_popで要素を取り出せる
    assert_equal('c', @stack.pop.pop.top)
  end

  def test_pushで要素をスタックに積める
    assert_equal('y', @stack.push('x').push('y').top)
    assert_equal('x', @stack.push('x').push('y').pop.top)
  end
end
