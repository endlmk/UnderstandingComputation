require 'minitest/autorun'
require_relative 'Assign'
require_relative 'Number'
require_relative 'Add'
require_relative 'Variable'

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
end
