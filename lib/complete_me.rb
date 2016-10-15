require './lib/node'

class CompleteMe < Node
  attr_reader :root
  def initialize
    @root = Node.new
  end

  def insert(word)
    @root.insert(word)
  end
end