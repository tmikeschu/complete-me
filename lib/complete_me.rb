require './lib/node'

class CompleteMe
  attr_reader :root,
              :library

  def initialize
    @root    = Node.new
    @library = Hash.new
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
    if library.keys.include?(word)
      weighted = sort_suggestions_by_weight(word)
      others = root.suggest(word)
      if others
        weighted + others
      else
        weighted
      end 
    else
      root.suggest(word)
    end
  end

  def select(substring, word)
    if library[substring].nil?
      add_substring_and_string_to_library(substring, word)
    else
      increment_word_count(substring, word)
    end
  end

  def add_substring_and_string_to_library(substring, word)
      library[substring] = {word => 1}    
  end

  def increment_word_count(substring, word)
    if library[substring][word]
      library[substring][word] += 1
    else
      library[substring][word] = 1 
    end
  end

  def sort_suggestions_by_weight(substring)
    sorted = library[substring].sort_by {|word, val| val}.reverse
    sorted.map!{|pair| pair.first}
  end

end