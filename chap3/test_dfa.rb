require "minitest/autorun"
require_relative 'FARules'

class TestDFA < Minitest::Test
  def test_firsttest
    test = FARules.new()
    assert_equal(true, true)
  end
end
