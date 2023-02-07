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

  def test_ペアを処理できる
    my_pair = PAIR[THREE][FIVE]
    assert_equal(3, to_integer(LEFT[my_pair]))
    assert_equal(5, to_integer(RIGHT[my_pair]))
  end

  def test_数値演算できる
    assert_equal(1, to_integer(INCREMENT[ZERO]))

    assert_equal(4, to_integer(DECREMENT[FIVE]))
    assert_equal(14, to_integer(DECREMENT[FIFTEEN]))
    assert_equal(99, to_integer(DECREMENT[HUNDRED]))
    assert_equal(0, to_integer(DECREMENT[ZERO]))

    assert_equal(6, to_integer(ADD[ONE][FIVE]))
    assert_equal(8, to_integer(ADD[THREE][FIVE]))
    assert_equal(3, to_integer(SUBTRACT[FIVE][TWO]))
    assert_equal(15, to_integer(MULTIPLY[THREE][FIVE]))
    assert_equal(8, to_integer(POWER[TWO][THREE]))

    assert_equal(true, to_boolean(IS_LESS_OR_EQUAL[ONE][TWO]))
    assert_equal(true, to_boolean(IS_LESS_OR_EQUAL[TWO][TWO]))
    assert_equal(false, to_boolean(IS_LESS_OR_EQUAL[THREE][TWO]))

    assert_equal(1, to_integer(MOD[THREE][TWO]))
    assert_equal(2, to_integer(MOD[POWER[THREE][THREE]][ADD[THREE][TWO]]))
  end

  def test_リストを扱える
    my_list = UNSHIFT[UNSHIFT[UNSHIFT[EMPTY][THREE]][TWO]][ONE]
    assert_equal(1, to_integer(FIRST[my_list]))
    assert_equal(2, to_integer(FIRST[REST[my_list]]))
    assert_equal(3, to_integer(FIRST[REST[REST[my_list]]]))
    assert_equal(false, to_boolean(IS_EMPTY[my_list]))
    assert_equal(true, to_boolean(IS_EMPTY[EMPTY]))

    assert_equal([1, 2, 3], to_array(my_list).map { |p| to_integer(p) })
  end

  def test_rangeを扱える
    my_range = RANGE[ONE][FIVE]
    assert_equal([1, 2, 3, 4, 5], to_array(my_range).map { |p| to_integer(p) })
  end

  def test_mapを扱える
    assert_equal(15, to_integer(FOLD[RANGE[ONE][FIVE]][ZERO][ADD]))
    assert_equal(120, to_integer(FOLD[RANGE[ONE][FIVE]][ONE][MULTIPLY]))

    my_list = MAP[RANGE[ONE][FIVE]][INCREMENT]
    assert_equal([2, 3, 4, 5, 6], to_array(my_list).map {|p| to_integer(p)})
  end
end
