require 'minitest/autorun'
require_relative 'Assign'
require_relative 'Number'
require_relative 'Add'
require_relative 'Variable'
require_relative 'Machine'
require_relative 'If'
require_relative 'Boolean'
require_relative 'DoNothing'
require_relative 'Sequence'
require_relative 'LessThan'
require_relative 'Multiply'
require_relative 'While'

class TestStatement < MiniTest::Test
  def test_代入文を簡約できる
    st = Assign.new(:x, Number.new(1))
    env = {}
    assert_equal('<<x = 1>>', st.inspect)
    assert_equal(true, st.reducible?)

    st, env = st.reduce(env)
    assert_equal('<<do-nothing>>', st.inspect)
    assert_equal('{:x=><<1>>}', env.inspect)
    assert_equal(false, st.reducible?)
  end

  def test_代入文の式の簡約を含めて簡約できる
    st = Assign.new(:x, Add.new(Variable.new(:x), Number.new(1)))
    env = { x: Number.new(2) }
    assert_equal('<<x = x + 1>>', st.inspect)
    assert_equal(true, st.reducible?)

    st, env = st.reduce(env)
    assert_equal('<<x = 2 + 1>>', st.inspect)
    assert_equal(true, st.reducible?)

    st, env = st.reduce(env)
    assert_equal('<<x = 3>>', st.inspect)
    assert_equal(true, st.reducible?)

    st, env = st.reduce(env)
    assert_equal('<<do-nothing>>', st.inspect)
    assert_equal('{:x=><<3>>}', env.inspect)
    assert_equal(false, st.reducible?)
  end

  def test_仮想機械で代入文を扱える
    vm = Machine.new(Assign.new(:x, Add.new(Variable.new(:x), Number.new(1))),
                     { x: Number.new(2) })

    result = 'x = x + 1, {:x=><<2>>}' << '\n' \
             'x = 2 + 1, {:x=><<2>>}' << '\n' \
             'x = 3, {:x=><<2>>}' << '\n' \
             'do-nothing, {:x=><<3>>}'

    assert_equal(result, vm.run)
  end

  def test_if文を扱える
    vm = Machine.new(
      If.new(
        Variable.new(:x),
        Assign.new(:y, Number.new(1)),
        Assign.new(:y, Number.new(2))
      ),
      { x: Boolean.new(true) }
    )

    result = 'if (x) { y = 1 } else { y = 2 }, {:x=><<true>>}' << '\n' \
             'if (true) { y = 1 } else { y = 2 }, {:x=><<true>>}' << '\n' \
             'y = 1, {:x=><<true>>}' << '\n' \
             'do-nothing, {:x=><<true>>, :y=><<1>>}'

    assert_equal(result, vm.run)
  end

  def test_elseなしのif文を扱える
    vm = Machine.new(
      If.new(
        Variable.new(:x),
        Assign.new(:y, Number.new(1)),
        DoNothing.new
      ),
      { x: Boolean.new(false) }
    )

    result = 'if (x) { y = 1 } else { do-nothing }, {:x=><<false>>}' << '\n' \
             'if (false) { y = 1 } else { do-nothing }, {:x=><<false>>}' << '\n' \
             'do-nothing, {:x=><<false>>}'

    assert_equal(result, vm.run)
  end

  def test_シーケンス文を簡約できる
    vm = Machine.new(
      Sequence.new(
        Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
        Assign.new(:y, Add.new(Variable.new(:x), Number.new(3)))
      ),
      {}
    )

    result = 'x = 1 + 1; y = x + 3, {}' << '\n' \
             'x = 2; y = x + 3, {}' << '\n' \
             'do-nothing; y = x + 3, {:x=><<2>>}' << '\n' \
             'y = x + 3, {:x=><<2>>}' << '\n' \
             'y = 2 + 3, {:x=><<2>>}' << '\n' \
             'y = 5, {:x=><<2>>}' << '\n' \
             'do-nothing, {:x=><<2>>, :y=><<5>>}'
    assert_equal(result, vm.run)
  end

  def test_While文を簡約できる
    vm = Machine.new(
      While.new(
        LessThan.new(Variable.new(:x), Number.new(5)),
        Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
      ),
      { x: Number.new(1) }
    )

    result = 'while (x < 5) { x = x * 3 }, {:x=><<1>>}' << '\n' \
             'if (x < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=><<1>>}' << '\n' \
             'if (1 < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=><<1>>}' << '\n' \
             'if (true) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=><<1>>}' << '\n' \
             'x = x * 3; while (x < 5) { x = x * 3 }, {:x=><<1>>}' << '\n' \
             'x = 1 * 3; while (x < 5) { x = x * 3 }, {:x=><<1>>}' << '\n' \
             'x = 3; while (x < 5) { x = x * 3 }, {:x=><<1>>}' << '\n' \
             'do-nothing; while (x < 5) { x = x * 3 }, {:x=><<3>>}' << '\n' \
             'while (x < 5) { x = x * 3 }, {:x=><<3>>}' << '\n' \
             'if (x < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=><<3>>}' << '\n' \
             'if (3 < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=><<3>>}' << '\n' \
             'if (true) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=><<3>>}' << '\n' \
             'x = x * 3; while (x < 5) { x = x * 3 }, {:x=><<3>>}' << '\n' \
             'x = 3 * 3; while (x < 5) { x = x * 3 }, {:x=><<3>>}' << '\n' \
             'x = 9; while (x < 5) { x = x * 3 }, {:x=><<3>>}' << '\n' \
             'do-nothing; while (x < 5) { x = x * 3 }, {:x=><<9>>}' << '\n' \
             'while (x < 5) { x = x * 3 }, {:x=><<9>>}' << '\n' \
             'if (x < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=><<9>>}' << '\n' \
             'if (9 < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=><<9>>}' << '\n' \
             'if (false) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=><<9>>}' << '\n' \
             'do-nothing, {:x=><<9>>}'
    assert_equal(result, vm.run)
  end
end
