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

INCREMENT = ->(n) { ->(p) { ->(x) { p[n[p][x]] } } }
SLIDE = ->(p) { PAIR[RIGHT[p]][INCREMENT[RIGHT[p]]] }
DECREMENT = ->(n) { LEFT[n[SLIDE][PAIR[ZERO][ZERO]]] }
ADD = ->(m) { ->(n) { n[INCREMENT][m] } }
SUBTRACT = ->(m) { ->(n) { n[DECREMENT][m] } }
MULTIPLY = ->(m) { ->(n) { n[ADD[m]][ZERO] } }
POWER = ->(m) { ->(n) { n[MULTIPLY[m]][ONE] } }
IS_LESS_OR_EQUAL = ->(l) { ->(r) { IS_ZERO[SUBTRACT[l][r]] } }
Y = ->(f) { ->(x) { f[x[x]] }[->(x) { f[x[x]] }] }
Z = ->(f) { ->(x) { f[->(y) { x[x][y] }] }[->(x) { ->(y) { f[x[x]][y] } }] }
MOD = Z[->(f) { ->(m) { ->(n) { IF[IS_LESS_OR_EQUAL[n][m]][ ->(x) { f[SUBTRACT[m][n]][n][x] }][m] } } }]

EMPTY = PAIR[TRUE][TRUE]
UNSHIFT = ->(l) { ->(x) { PAIR[FALSE][PAIR[x][l]] } }
IS_EMPTY = LEFT
FIRST = ->(l) { LEFT[RIGHT[l]] }
REST = ->(l) { RIGHT[RIGHT[l]] }

RANGE = Z[->(f) { ->(m) { ->(n) { IF[IS_LESS_OR_EQUAL[m][n]][->(x) { UNSHIFT[f[INCREMENT[m]][n]][m][x] }][EMPTY] } } } ]

FOLD = Z[->(f) { ->(l) { ->(x) { ->(g) { IF[IS_EMPTY[l]][x][->(y) { g[f[REST[l]][x][g]][FIRST[l]][y] }] } } } }]
MAP = ->(l) { ->(g) { FOLD[l][EMPTY][ ->(k) { ->(x) { UNSHIFT[k][g[x]] } }] } }

def to_integer(proc)
  proc[->(n) { n + 1 }][0]
end

def to_boolean(proc)
  proc[true][false]
end

def to_array(proc)
  array = []

  until to_boolean(IS_EMPTY[proc])
    array.push(FIRST[proc])
    proc = REST[proc]
  end
  array
end
