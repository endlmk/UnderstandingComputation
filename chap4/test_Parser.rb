require('minitest/autorun')
require_relative('LexicalAnalyzer')
require_relative('PDARule')
require_relative('NPDARulebook')
require_relative('NPDADesign')

class LexicalAnalyzerTest < MiniTest::Test
  def test_字句解析できる
    assert_equal(['v', '=', 'v', '*', 'n'], LexicalAnalyzer.new('y = x * 7').analyze)
    assert_equal(['w', '(', 'v', '<', 'n', ')', '{', 'v', '=', 'v', '*', 'n', '}'],
                 LexicalAnalyzer.new('while (x < 5) { x = x * 3 }').analyze)
    assert_equal(['i', '(', 'v', '<', 'n', ')', '{', 'v', '=', 'b', ';', 'v', '=', 'n', '}', 'e', '{', 'd', '}'],
                 LexicalAnalyzer.new('if (x < 10) { y = true; x = 0 } else { do-nothing }').analyze)
  end
end

class ParserTest < MiniTest::Test
  def setup
    start_rule = PDARule.new(1, nil, 2, '$', ['S', '$'])

    symbol_rules = [
      # <statement> ::= <while> | <assign>
      PDARule.new(2, nil, 2, 'S', ['W']),
      PDARule.new(2, nil, 2, 'S', ['A']),

      # <while> ::= 'w' '(' <expression> ')' '{' <statement> '}'
      PDARule.new(2, nil, 2, 'W', ['w', '(', 'E', ')', '{', 'S', '}']),

      # <assign> ::= 'v' '=' <expression>
      PDARule.new(2, nil, 2, 'A', ['v', '=', 'E']),

      # <expression> ::= <less-than>
      PDARule.new(2, nil, 2, 'E', ['L']),

      # <less-than> ::= <multiply> '<' <less-than> | <multiply>
      PDARule.new(2, nil, 2, 'L', ['M', '<', 'L']),
      PDARule.new(2, nil, 2, 'L', ['M']),

      # <multiply> ::= <term> '*' <multiply> | <term>
      PDARule.new(2, nil, 2, 'M', ['T', '*', 'M']),
      PDARule.new(2, nil, 2, 'M', ['T']),

      # <term> ::= 'n' | 'v'
      PDARule.new(2, nil, 2, 'T', ['n']),
      PDARule.new(2, nil, 2, 'T', ['v']),
    ]

    token_rules = LexicalAnalyzer::GRAMMER.map do |rule|
      PDARule.new(2, rule[:token], 2, rule[:token], [])
    end

    stop_rule = PDARule.new(2, nil, 3, '$', ['$'])

    rulebook = NPDARulebook.new([start_rule, stop_rule] + symbol_rules + token_rules)

    @npda_design = NPDADesign.new(1, '$', [3], rulebook)
  end

  def test_構文解析できる
    token_string = LexicalAnalyzer.new('while (x < 5) { x = x * 3 }').analyze.join
    assert_equal('w(v<n){v=v*n}', token_string)
    assert_equal(true, @npda_design.accepts?(token_string))
    assert_equal(false, @npda_design.accepts?(LexicalAnalyzer.new('while (x < 5 x = x * }').analyze.join))
  end
end
