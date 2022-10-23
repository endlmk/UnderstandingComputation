require('minitest/autorun')
require('set')
require_relative('NPDARulebook')
require_relative('Stack')
require_relative('PDARule')
require_relative('PDAConfiguration')
require_relative('NPDA')
require_relative('NPDADesign')

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

class NPDATest < MiniTest::Test
  def setup
    rulebook = NPDARulebook.new([
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
    configuration = PDAConfiguration.new(1, Stack.new(['$']))
    @npda = NPDA.new(Set[configuration], [3], rulebook)
  end

  def test_NPDAの受理状態を判定できる
    assert_equal(true, @npda.accepting?)
  end

  def test_NPDAの現在の状態を得られる
    assert_equal(Set[PDAConfiguration.new(1, Stack.new(['$'])),
                     PDAConfiguration.new(2, Stack.new(['$'])),
                     PDAConfiguration.new(3, Stack.new(['$']))],
                 @npda.current_configurations)
  end

  def test_NPDAに文字列を与えて状態が変わる
    @npda.read_string('abb')
    assert_equal(false, @npda.accepting?)
    assert_equal(Set[PDAConfiguration.new(1, Stack.new(['b', 'b', 'a', '$'])),
                     PDAConfiguration.new(2, Stack.new(['a', '$'])),
                     PDAConfiguration.new(2, Stack.new(['b', 'b', 'a', '$']))],
                 @npda.current_configurations)

    @npda.read_character('a')
    assert_equal(true, @npda.accepting?)
    assert_equal(Set[PDAConfiguration.new(1, Stack.new(['a', 'b', 'b', 'a', '$'])),
                     PDAConfiguration.new(2, Stack.new(['$'])),
                     PDAConfiguration.new(2, Stack.new(['a', 'b', 'b', 'a', '$'])),
                     PDAConfiguration.new(3, Stack.new(['$']))],
                 @npda.current_configurations)
  end
end

class NPDADesignTest < MiniTest::Test
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
  def test_NPDADesignで初期状態から入力を与えられる
    npda_design = NPDADesign.new(1, '$', [3], @rulebook)
    assert_equal(true, npda_design.accepts?('abba'))
    assert_equal(true, npda_design.accepts?('babbaabbab'))
    assert_equal(false, npda_design.accepts?('abb'))
    assert_equal(false, npda_design.accepts?('baabaa'))
  end
end