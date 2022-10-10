class Stack < Struct.new(:contents)
  def top
    contents.first
  end

  def pop
    Stack.new(contents.drop(1))
  end

  def push(elem)
    Stack.new(contents.unshift(elem))
  end

  def inspect
    "#<Stack (#{top})#{contents.drop(1).join}>"
  end
end
