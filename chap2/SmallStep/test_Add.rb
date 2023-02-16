require 'minitest/autorun'
require_relative 'Number'
require_relative 'Add'
require_relative 'Multiply'
require_relative 'Machine'
require_relative 'LessThan'
require_relative 'Variable'

class TestAdd < MiniTest::Test
  include SmallStep
  def test_Addの抽象構文木を作れる
    add = Add.new(
      Multiply.new(Number.new(1), Number.new(2)),
      Multiply.new(Number.new(3), Number.new(4))
    )
    assert_equal('<<1 * 2 + 3 * 4>>', add.inspect)
  end

  def test_簡約可能か判定できる
    assert_equal(false, Number.new(1).reducible?)
    assert_equal(true, Add.new(Number.new(1), Number.new(2)).reducible?)
  end

  def test_式を評価できる
    expression = Add.new(
      Multiply.new(Number.new(1), Number.new(2)),
      Multiply.new(Number.new(3), Number.new(4))
    )
    assert_equal(true, expression.reducible?)

    expression = expression.reduce({})
    assert_equal('<<2 + 3 * 4>>', expression.inspect)
    assert_equal(true, expression.reducible?)

    expression = expression.reduce({})
    assert_equal('<<2 + 12>>', expression.inspect)
    assert_equal(true, expression.reducible?)

    expression = expression.reduce({})
    assert_equal('<<14>>', expression.inspect)
    assert_equal(false, expression.reducible?)
  end

  def test_仮想機械が簡約を実行する
    vm = Machine.new(
      Add.new(
        Multiply.new(Number.new(1), Number.new(2)),
        Multiply.new(Number.new(3), Number.new(4))
      ),
      {}
    )

    result = '1 * 2 + 3 * 4, {}' << '\n' \
             '2 + 3 * 4, {}' << '\n' \
             '2 + 12, {}' << '\n' \
             '14, {}'
    assert_equal(result, vm.run)
  end

  def test_ブール式を簡約できる
    vm = Machine.new(
      LessThan.new(Number.new(5), Add.new(Number.new(2), Number.new(2))),
      {}
    )

    result = '5 < 2 + 2, {}' << '\n' <<
             '5 < 4, {}' << '\n' <<
             'false, {}'
    assert_equal(result, vm.run)
  end

  def test_変数を含む式を簡約できる
    vm = Machine.new(
      Add.new(Variable.new(:x), Variable.new(:y)),
      { x: Number.new(3), y: Number.new(4) }
    )

    result = 'x + y, {:x=><<3>>, :y=><<4>>}' << '\n' \
             '3 + y, {:x=><<3>>, :y=><<4>>}' << '\n' \
             '3 + 4, {:x=><<3>>, :y=><<4>>}' << '\n' \
             '7, {:x=><<3>>, :y=><<4>>}'
    assert_equal(result, vm.run)
  end
end
