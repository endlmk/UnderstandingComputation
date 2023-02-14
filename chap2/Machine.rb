class Machine < Struct.new(:expression, :environment)
  def run
    s = ''
    while expression.reducible?
      s << expression.to_s
      s += '\n'
      self.expression = expression.reduce(environment)
    end
    s << expression.to_s
    s
  end
end
