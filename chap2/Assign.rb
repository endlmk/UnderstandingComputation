require_relative 'DoNothing'

class Assign < Struct.new(:name, :expression)
  def to_s
    "#{name} = #{expression}"
  end

  def inspect
    "<<#{self}>>"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if expression.reducible?
      [Assign.new(name, expression.reduce(environment)), environment]
    else
      new_environment = environment.merge(Hash[name, expression])
      [DoNothing.new, new_environment]
    end
  end
end
