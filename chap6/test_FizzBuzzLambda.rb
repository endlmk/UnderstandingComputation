require('minitest/autorun')
require_relative('FizzBuzzLambda')

class FizzBuzzLambdaTest < MiniTest::Test
  def test_数を表示できる
    assert_equal(0, to_integer(ZERO))
    assert_equal(1, to_integer(ONE))
    assert_equal(2, to_integer(TWO))
    assert_equal(3, to_integer(THREE))
    assert_equal(5, to_integer(FIVE))
    assert_equal(15, to_integer(FIFTEEN))
    assert_equal(100, to_integer(HUNDRED))
  end

  def test_bool値を表示できる
    assert_equal(true, to_boolean(TRUE))
    assert_equal(false, to_boolean(FALSE))
  end

  def test_ifを処理できる
    assert_equal('happy', IF[TRUE]['happy']['sad'])
    assert_equal('sad', IF[FALSE]['happy']['sad'])
  end

  def test_述語を処理できる
    assert_equal(true, to_boolean(IS_ZERO[ZERO]))
    assert_equal(false, to_boolean(IS_ZERO[ONE]))
  end
end
