class Stack < Struct.new(:contents)
  def top
    contents.first
  end
end