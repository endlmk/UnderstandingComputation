class Machine < Struct.new(:expression, :environment)
  def run
    s = ''
    while expression.reducible?
      s << "#{expression}, #{environment}"
      s += '\n'
      self.expression, env = expression.reduce(environment)
      self.environment = env unless env.nil?
    end
    s << "#{expression}, #{environment}"
    s
  end
end
