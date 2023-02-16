class Boolean < Struct.new(:value)
  def to_s
    value.to_s
  end

  def inspect
    "<<#{self}>>"
  end

  def evaluate(_environment)
    self
  end
end
