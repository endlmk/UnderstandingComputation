require('minitest/autorun')
require_relative('DTM')

class DTMTest < MiniTest::Test
  def test_ルールブックから次のConfigurationを得られる
    rulebook = DTMRulebook.new([
      TMRule.new(1, '0', 2, '1', :right),
      TMRule.new(1, '1', 1, '0', :left),
      TMRule.new(1, '_', 2, '1', :right),
      TMRule.new(2, '0', 2, '0', :right),
      TMRule.new(2, '1', 2, '1', :right),
      TMRule.new(2, '_', 3, '_', :left)
    ])

    tape = Tape.new(['1', '0', '1'], '1', [], '_')
    
    configuration = TMConfiguration.new(1, tape)
    
    configuration = rulebook.next_configuration(configuration)
    assert_equal(
      TMConfiguration.new(1, Tape.new(['1', '0'], '1', ['0'], '_')),
      configuration
    )

    configuration = rulebook.next_configuration(configuration)
    assert_equal(
      TMConfiguration.new(1, Tape.new(['1'], '0', ['0', '0'], '_')),
      configuration
    )
    
    configuration = rulebook.next_configuration(configuration)
    assert_equal(
      TMConfiguration.new(2, Tape.new(['1', '1'], '0', ['0'], '_')),
      configuration
    )
  end

  def test_DTMが動作する
    rulebook = DTMRulebook.new([
      TMRule.new(1, '0', 2, '1', :right),
      TMRule.new(1, '1', 1, '0', :left),
      TMRule.new(1, '_', 2, '1', :right),
      TMRule.new(2, '0', 2, '0', :right),
      TMRule.new(2, '1', 2, '1', :right),
      TMRule.new(2, '_', 3, '_', :left)
    ])
    tape = Tape.new(['1', '0', '1'], '1', [], '_')
    dtm = DTM.new(TMConfiguration.new(1, tape), [3], rulebook)

    assert_equal(
      TMConfiguration.new(1, Tape.new(['1', '0', '1'], '1', [], '_')),
      dtm.current_configuration
    )
    assert_equal(false, dtm.accepting?)

    dtm.step
    assert_equal(
      TMConfiguration.new(1, Tape.new(['1', '0'], '1', ['0'], '_')),
      dtm.current_configuration
    )
    assert_equal(false, dtm.accepting?)

    dtm.run
    assert_equal(
      TMConfiguration.new(3, Tape.new(['1', '1', '0'], '0', ['_'], '_')),
      dtm.current_configuration
    )
    assert_equal(true, dtm.accepting?)
  end

  def test_行き詰まりになると停止する
    rulebook = DTMRulebook.new([
      TMRule.new(1, '0', 2, '1', :right),
      TMRule.new(1, '1', 1, '0', :left),
      TMRule.new(1, '_', 2, '1', :right),
      TMRule.new(2, '0', 2, '0', :right),
      TMRule.new(2, '1', 2, '1', :right),
      TMRule.new(2, '_', 3, '_', :left)
    ])
    tape = Tape.new(['1', '2', '1'], '1', [], '_')
    dtm = DTM.new(TMConfiguration.new(1, tape), [3], rulebook)

    dtm.run
    assert_equal(
      TMConfiguration.new(1, Tape.new(['1'], '2', ['0', '0'], '_')),
      dtm.current_configuration
    )
    assert_equal(false, dtm.accepting?)
    assert_equal(true, dtm.stuck?)
  end

  def test_1個以上のaにbとcが同じ数だけ続く文字列を認識する
    rulebook = DTMRulebook.new([
      TMRule.new(1, 'X', 1, 'X', :right),
      TMRule.new(1, 'a', 2, 'X', :right),
      TMRule.new(1, '_', 6, '_', :left),

      TMRule.new(2, 'a', 2, 'a', :right),
      TMRule.new(2, 'X', 2, 'X', :right),
      TMRule.new(2, 'b', 3, 'X', :right),

      TMRule.new(3, 'b', 3, 'b', :right),
      TMRule.new(3, 'X', 3, 'X', :right),
      TMRule.new(3, 'c', 4, 'X', :right),
      
      TMRule.new(4, 'c', 4, 'c', :right),
      TMRule.new(4, '_', 5, '_', :left),

      TMRule.new(5, 'a', 5, 'a', :left),
      TMRule.new(5, 'b', 5, 'b', :left),
      TMRule.new(5, 'c', 5, 'c', :left),
      TMRule.new(5, 'X', 5, 'X', :left),
      TMRule.new(5, '_', 1, '_', :right),
    ])

    tape = Tape.new([], 'a', ['a', 'a', 'b', 'b', 'b', 'c', 'c', 'c'], '_')
    dtm = DTM.new(TMConfiguration.new(1, tape), [6], rulebook)

    10.times { dtm.step }
    assert_equal(
      TMConfiguration.new(5, Tape.new(['X', 'a', 'a', 'X', 'b', 'b', 'X', 'c'], 'c', ['_'], '_')),
      dtm.current_configuration
    )

    25.times { dtm.step }
    assert_equal(
      TMConfiguration.new(5, Tape.new(['_', 'X', 'X', 'a'], 'X', ['X', 'b', 'X', 'X', 'c', '_'], '_')),
      dtm.current_configuration
    )
    
    dtm.run
    assert_equal(
      TMConfiguration.new(6, Tape.new(['_', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'], 'X', ['_'], '_')),
      dtm.current_configuration
    )
  end
end

class DTMInternalStorageTest < MiniTest::Test
  def test_内部ストレージを持つDTM
    rulebook = DTMRulebook.new([
      TMRule.new(1, 'a', 2, 'a', :right),
      TMRule.new(1, 'b', 3, 'b', :right),
      TMRule.new(1, 'c', 4, 'c', :right),

      TMRule.new(2, 'a', 2, 'a', :right),
      TMRule.new(2, 'b', 2, 'b', :right),
      TMRule.new(2, 'c', 2, 'c', :right),
      TMRule.new(2, '_', 5, 'a', :right),
      
      TMRule.new(3, 'a', 3, 'a', :right),
      TMRule.new(3, 'b', 3, 'b', :right),
      TMRule.new(3, 'c', 3, 'c', :right),
      TMRule.new(3, '_', 5, 'b', :right),
      
      TMRule.new(4, 'a', 4, 'a', :right),
      TMRule.new(4, 'b', 4, 'b', :right),
      TMRule.new(4, 'c', 4, 'c', :right),
      TMRule.new(4, '_', 5, 'b', :right),
    ])

    tape = Tape.new([], 'b', ['c', 'b', 'c', 'a'], '_')

    dtm = DTM.new(TMConfiguration.new(1, tape), [5], rulebook)
    dtm.run

    assert_equal(Tape.new(['b', 'c', 'b', 'c', 'a', 'b'], '_', [], '_'), dtm.current_configuration.tape)
  end
end

class DTMCombineTest < MiniTest::Test
  def test_機械の状態と規則を複数つなげたDTM
    def incremenet_rules(start_state, return_state)
      incrementing = start_state
      finishing = Object.new
      finished = return_state

      [
        TMRule.new(incrementing, '0', finishing, '1', :right),
        TMRule.new(incrementing, '1', incrementing, '0', :left),
        TMRule.new(incrementing, '_', finishing, '1', :right),
        TMRule.new(finishing, '0', finishing, '0', :right),
        TMRule.new(finishing, '1', finishing, '1', :right),
        TMRule.new(finishing, '_', finished, '_', :left),
      ]
    end
    
    add_zero, add_one, add_two, add_three = 0, 1, 2, 3
    rulebook = DTMRulebook.new(
      incremenet_rules(add_zero, add_one) +
      incremenet_rules(add_one, add_two) +
      incremenet_rules(add_two, add_three)
    )
    assert_equal(18, rulebook.rules.length)

    tape = Tape.new(['1', '0', '1'], '1', [], '_')
    dtm = DTM.new(TMConfiguration.new(add_zero, tape), [add_three], rulebook)
    
    dtm.run

    assert_equal(Tape.new(['1', '1', '1'], '0', ['_'], '_'), dtm.current_configuration.tape)
  end
end
