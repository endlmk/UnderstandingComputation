require 'minitest/autorun'
require_relative 'Assign'
require_relative 'Add'
require_relative 'Variable'
require_relative 'Number'
require_relative 'Boolean'
require_relative 'Multiply'
require_relative 'If'
require_relative 'Sequence'
require_relative 'While'
require_relative 'LessThan'

module Denotational
  class StatementTest < MiniTest::Test
    def test_代入を評価できる
      proc = eval(Assign.new(:y, Add.new(Variable.new(:x), Number.new(1))).to_ruby)
      assert_equal('{:x=>3, :y=>4}', proc.call({ x: 3 }).inspect)
    end

    def test_if文を評価できる
      proc = eval(If.new(Boolean.new(true), Add.new(Variable.new(:x), Number.new(1)),
                         Multiply.new(Number.new(2), Variable.new(:x))).to_ruby)
      assert_equal(4, proc.call({ x: 3 }))

      proc = eval(If.new(Boolean.new(false), Add.new(Variable.new(:x), Number.new(1)),
                         Multiply.new(Number.new(2), Variable.new(:x))).to_ruby)
      assert_equal(6, proc.call({ x: 3 }))
    end

    def test_Sequenceを評価できる
      proc = eval(Sequence.new(
        Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
        Assign.new(:y, Add.new(Variable.new(:x), Number.new(3)))
      ).to_ruby)
      assert_equal('{:x=>2, :y=>5}', proc.call({}).inspect)
    end

    def test_while文を評価できる
      st = eval(While.new(
        LessThan.new(Variable.new(:x), Number.new(5)),
        Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
      ).to_ruby)
      assert_equal('{:x=>9}', st.call({ x: 1 }).inspect)
    end
  end
end
