require('minitest/autorun')
require('set')
require_relative('NPDARulebook')
require_relative('Stack')
require_relative('PDARule')
require_relative('PDAConfiguration')

class NPDARulebookTest < MiniTest::Test
  def setup
    @rulebook = NPDARulebook.new([
        PDARule.new(1, 'a', 1, '$', ['a', '$']),
        PDARule.new(1, 'a', 1, 'a', ['a', 'a']),
        PDARule.new(1, 'a', 1, 'b', ['a', 'b']),
        PDARule.new(1, 'b', 1, '$', ['b', '$']),
        PDARule.new(1, 'b', 1, 'a', ['b', 'a']),
        PDARule.new(1, 'b', 1, 'b', ['b', 'b']),
        PDARule.new(1, nil, 2, '$', ['$']),
        PDARule.new(1, nil, 2, 'a', ['a']),
        PDARule.new(1, nil, 2, 'b', ['b']),
        PDARule.new(2, 'a', 2, 'a', []),
        PDARule.new(2, 'b', 2, 'b', []),
        PDARule.new(2, nil, 3, '$', ['$'])
      ])
  end

  def test_NPDARulebookで状態遷移できる
    configuration = PDAConfiguration.new(1, Stack.new(['$']))
    next_config = @rulebook.next_configurations(Set[configuration], 'a')
    assert_equal(Set[PDAConfiguration.new(1, Stack.new(['a', '$']))],
                 next_config)
  end
  def test_自由移動した状態を得られる
    configuration = PDAConfiguration.new(1, Stack.new(['a', '$']))
    configs = @rulebook.follow_free_moves(Set[configuration])

    assert_equal(Set[PDAConfiguration.new(1, Stack.new(['a', '$'])),
                     PDAConfiguration.new(2, Stack.new(['a', '$']))],
                 configs)
  end
end
