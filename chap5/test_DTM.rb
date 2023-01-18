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
end
