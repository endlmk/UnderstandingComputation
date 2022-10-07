require('minitest/autorun')
require_relative('PDARule')
require_relative('Stack')
require_relative('PDAConfiguration')

class PDARuleTest < MiniTest::Test
  def test_PDARuleがPDAConfigureationを受け入れる
    rule = PDARule.new(1, '(', 2, '$', ['b', '$'])
    configuration = PDAConfiguration.new(1, Stack.new(['$']))
    assert_equal(true, rule.applies_to?(configuration, '('))
  end
end
