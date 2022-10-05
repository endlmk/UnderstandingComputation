require('minitest/autorun')
require_relative('Stack')

class StackTest < MiniTest::Test
  def test_topで最上位を取得できる
    stack = Stack.new(['a', 'b', 'c', 'd', 'e'])
    assert_equal('a', stack.top)
  end
end
