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

  def populate(converted_file)
    root.populate(converted_file)
  end

  def suggest(word = "")
    root.suggest(word)
  end

  def select(substring, word)
    root.select(substring, word)
  end

end