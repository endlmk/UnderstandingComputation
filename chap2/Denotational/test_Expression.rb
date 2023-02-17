require 'minitest/autorun'
require_relative 'Number'
require_relative 'Boolean'
require_relative 'Variable'
require_relative 'Add'
require_relative 'Multiply'
require_relative 'LessThan'

module Denotational
  class ExpressionTest < MiniTest::Test
    def test_数字と文字を評価できる
      proc = eval(Number.new(5).to_ruby)
      assert_equal(5, proc.call({}))

      proc = eval(Boolean.new(false).to_ruby)
      assert_equal(false, proc.call({}))
    end

    def test_変数を評価できる
      proc = eval(Variable.new(:x).to_ruby)
      assert_equal(7, proc.call({ x: 7 }))
    end

    def test_演算式を評価できる
      env = { x: 3 }
      proc = eval(Add.new(Variable.new(:x), Number.new(1)).to_ruby)
      assert_equal(4, proc.call(env))

      proc = eval(Multiply.new(Variable.new(:x), Number.new(2)).to_ruby)
      assert_equal(6, proc.call(env))

      proc = eval(
        LessThan.new(Add.new(Variable.new(:x), Number.new(1)), Number.new(3)).to_ruby
      )
      assert_equal(false, proc.call(env))
    end
  end
end
