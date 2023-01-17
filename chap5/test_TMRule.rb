require('minitest/autorun')
require_relative('Tape')
require_relative('TMConfiguration')
require_relative('TMRule')

class TapeTest < MiniTest::Test
  def test_ルールがTMConfigurationを受け入れる
    rule = TMRule.new(1, '0', 2, '1', :right)

    assert_equal(true, rule.applies_to?(TMConfiguration.new(1, Tape.new([], '0', [], '_'))))
    assert_equal(false, rule.applies_to?(TMConfiguration.new(1, Tape.new([], '1', [], '_'))))
    assert_equal(false, rule.applies_to?(TMConfiguration.new(2, Tape.new([], '0', [], '_'))))
  end

  def test_ルールが次のTMConfigurationを返す
    rule = TMRule.new(1, '0', 2, '1', :right)
    assert_equal(
      TMConfiguration.new(2, Tape.new(['1'], '_', [], '_')),
      rule.follow(TMConfiguration.new(1, Tape.new([], '0', [], '_')))
    )
  end
end
