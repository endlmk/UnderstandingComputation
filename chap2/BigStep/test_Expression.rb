require 'minitest/autorun'
require_relative 'Number'
require_relative 'Variable'
require_relative 'LessThan'
require_relative 'Add'

module BigStep
  class ExpressionTest < MiniTest::Test
    def test_式を評価できる
      assert_equal('<<23>>', Number.new(23).evaluate({}).inspect)

      assert_equal('<<23>>', Variable.new(:x).evaluate({ x: Number.new(23) }).inspect)

      assert_equal('<<true>>', LessThan.new(
        Add.new(Variable.new(:x), Number.new(2)),
        Variable.new(:y)
      ).evaluate({ x: Number.new(2), y: Number.new(5) }).inspect)
    end
  end
end
