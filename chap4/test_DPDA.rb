require('minitest/autorun')
require_relative('Stack')
require_relative('PDARule')
require_relative('PDAConfiguration')
require_relative('DPDARulebook')
require_relative('DPDA')
require_relative('DPDADesign')

class DPDARulebookTest < MiniTest::Test
  def setup
    @rulebook = DPDARulebook.new([
        PDARule.new(1, '(', 2, '$', ['b', '$']),
        PDARule.new(2, '(', 2, 'b', ['b', 'b']),
        PDARule.new(2, ')', 2, 'b', []),
        PDARule.new(2, nil, 1, '$', ['$'])
    ])
  end

  def test_DPDAのための規則集を作れる
    configuration = PDAConfiguration.new(1, Stack.new(['$']))
    configuration = @rulebook.next_configuration(configuration, '(')
    assert_equal(PDAConfiguration.new(2, Stack.new(['b', '$'])), configuration)
    configuration = @rulebook.next_configuration(configuration, '(')
    assert_equal(PDAConfiguration.new(2, Stack.new(['b', 'b', '$'])), configuration)
    configuration = @rulebook.next_configuration(configuration, ')')
    assert_equal(PDAConfiguration.new(2, Stack.new(['b', '$'])), configuration)
  end

  def test_自由移動できる
    configuration = PDAConfiguration.new(2, Stack.new(['$']))
    assert_equal(PDAConfiguration.new(1, Stack.new(['$'])), @rulebook.follow_free_moves(configuration))
  end
end

class DPDATest < MiniTest::Test
  def setup
    rulebook = DPDARulebook.new([
        PDARule.new(1, '(', 2, '$', ['b', '$']),
        PDARule.new(2, '(', 2, 'b', ['b', 'b']),
        PDARule.new(2, ')', 2, 'b', []),
        PDARule.new(2, nil, 1, '$', ['$'])
    ])
    @dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], rulebook)
  end
  def test_DPDAを生成し入力を与え受理されるかどうか調べられる
    assert_equal(true, @dpda.accepting?)
    @dpda.read_string('(()')
    assert_equal(false, @dpda.accepting?)
    assert_equal(PDAConfiguration.new(2, Stack.new(['b', '$'])), @dpda.current_configuration)
  end

  def test_自由移動を含め受理されるかチェックできる
    @dpda.read_string('(()(')
    assert_equal(false, @dpda.accepting?)
    assert_equal(PDAConfiguration.new(2, Stack.new(['b', 'b', '$'])), @dpda.current_configuration)
    @dpda.read_string('))()')
    assert_equal(true, @dpda.accepting?)
    assert_equal(PDAConfiguration.new(1, Stack.new(['$'])), @dpda.current_configuration)
  end

  def test_行き詰まり状態になる
    @dpda.read_string('())')
    assert_equal(Stack.new(['$']), @dpda.current_configuration.stack)
    assert_equal(false, @dpda.accepting?)
    assert_equal(true, @dpda.stuck?)
  end
end

class DPDADesignTest < MiniTest::Test
  def setup
    rulebook = DPDARulebook.new([
        PDARule.new(1, '(', 2, '$', ['b', '$']),
        PDARule.new(2, '(', 2, 'b', ['b', 'b']),
        PDARule.new(2, ')', 2, 'b', []),
        PDARule.new(2, nil, 1, '$', ['$'])
    ])
    @dpda_design = DPDADesign.new(1, '$', [1], rulebook)
  end

  def test_文字列をチェックできる
    assert_equal(true, @dpda_design.accepts?('(((((((((())))))))))'))
    assert_equal(true, @dpda_design.accepts?('()(())((()))(()(()))'))
    assert_equal(false, @dpda_design.accepts?('(()(()(()()(()()))()'))
  end

  def test_行き詰まり状態は受理しない
    assert_equal(false, @dpda_design.accepts?('())'))
  end
end
