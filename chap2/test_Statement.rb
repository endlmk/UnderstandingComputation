require 'minitest/autorun'
require_relative 'Assign'
require_relative 'Number'
require_relative 'Add'
require_relative 'Variable'
require_relative 'Machine'
require_relative 'If'
require_relative 'Boolean'
require_relative 'DoNothing'

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
end
