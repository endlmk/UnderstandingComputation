require('minitest/autorun')
require_relative('Tape')

class TapeTest < MiniTest::Test
  def test_テープヘッドの下を読める
    tape = Tape.new(['1', '0', '1'], '1', [], '_')
    assert_equal('1', tape.middle)
  end

  def test_ヘッドを動かせる
    tape = Tape.new(['1', '0', '1'], '1', [], '_')

    assert_equal(['1', '0'], tape.move_head_left.left)
    assert_equal('1', tape.move_head_left.middle)
    assert_equal(['1'], tape.move_head_left.right)

    assert_equal(['1', '0', '1', '1'], tape.move_head_right.left)
    assert_equal('_', tape.move_head_right.middle)
    assert_equal([], tape.move_head_right.right)
  end

  def test_ヘッドの下に書き込める
    tape = Tape.new(['1', '0', '1'], '1', [], '_')

    assert_equal(['1', '0', '1'], tape.write('0').left)
    assert_equal('0', tape.write('0').middle)
    assert_equal([], tape.write('0').right)

    assert_equal(['1', '0', '1', '1'], tape.move_head_right.write('0').left)
    assert_equal('0', tape.move_head_right.write('0').middle)
    assert_equal([], tape.move_head_right.write('0').right)
  end
end
