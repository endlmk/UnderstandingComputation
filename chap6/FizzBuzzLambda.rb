ZERO = ->(_p) { ->(x) { x } }
ONE = ->(p) { ->(x) { p[x] } }
TWO = ->(p) { ->(x) { p[p[x]] } }
THREE = ->(p) { ->(x) { p[p[p[x]]] } }
FIVE = ->(p) { ->(x) { p[p[p[p[p[x]]]]] } }
FIFTEEN = ->(p) { ->(x) { p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]] } }
HUNDRED = lambda { |p|
  lambda { |x|
    p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
  }
}

TRUE = ->(x) { ->(_y) { x } }
FALSE = ->(_x) { ->(y) { y } }
IF = ->(b) { b }

IS_ZERO = ->(n) { n[->(_x) { FALSE }][TRUE] }

PAIR = ->(x) { ->(y) { ->(f) { f[x][y] } } }
LEFT = ->(p) { p[->(x) { ->(_y) { x } }] }
RIGHT = ->(p) { p[->(_x) { ->(y) { y } }] }

def to_integer(proc)
  proc[->(n) { n + 1 }][0]
end

def to_boolean(proc)
  proc[true][false]
end
