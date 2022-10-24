require('minitest/autorun')
require_relative('LexicalAnalyzer')

class LexicalAnalyzerTest < MiniTest::Test
  def test_字句解析できる
    assert_equal(['v', '=', 'v', '*', 'n'], LexicalAnalyzer.new('y = x * 7').analyze)
    assert_equal(['w', '(', 'v', '<', 'n', ')', '{', 'v', '=', 'v', '*', 'n', '}'],
                 LexicalAnalyzer.new('while (x < 5) { x = x * 3 }').analyze)
    assert_equal(['i', '(', 'v', '<', 'n', ')', '{', 'v', '=', 'b', ';', 'v', '=', 'n', '}', 'e', '{', 'd', '}'],
                 LexicalAnalyzer.new('if (x < 10) { y = true; x = 0 } else { do-nothing }').analyze)
  end
end
