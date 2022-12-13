require('minitest/autorun')
require_relative('Tape')

class TapeTest < MiniTest::Test
  def test_テープヘッドの下を読める
    tape = Tape.new(['1', '0', '1'], '1', [], '_')
    assert_equal('1' ,tape.middle)
  end
end
