require 'minitest/autorun'
require_relative 'Number'
require_relative 'Add'
require_relative 'Variable'
require_relative 'Sequence'
require_relative 'Assign'
require_relative 'If'
require_relative 'Boolean'
require_relative 'While'
require_relative 'LessThan'
require_relative 'Multiply'

class StatementTest < MiniTest::Test
  include BigStep
  def test_文を評価できる
    st = Sequence.new(
      Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
      Assign.new(:y, Add.new(Variable.new(:x), Number.new(3)))
    )
    assert_equal('{:x=><<2>>, :y=><<5>>}', st.evaluate({}).inspect)
  end

  def test_if文を評価できる
    st = If.new(
      Boolean.new(true),
      Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
      Assign.new(:y, Number.new(3))
    )
    assert_equal('{:x=><<2>>}', st.evaluate({}).inspect)
  end

  def test_while文を評価できる
    st = While.new(
      LessThan.new(Variable.new(:x), Number.new(5)),
      Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
    )
    assert_equal('{:x=><<9>>}', st.evaluate({ x: Number.new(1) }).inspect)
  end
end
