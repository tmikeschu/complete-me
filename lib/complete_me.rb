require './lib/node'

class CompleteMe
  attr_reader :root
  def initialize
    @root = Node.new
  end

  def insert(word)
    root.insert(word)
  end

  def count
    root.count
  end

  def populate(file)
    root.populate(file)
  end

  def suggest(word = "")
    root.suggest(word)
  end

end