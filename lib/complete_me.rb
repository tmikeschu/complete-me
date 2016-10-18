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
      check_library_for_similar_substrings(word)
    else
      root.suggest(word)
    end
  end

  def check_library_for_similar_substrings(word)
      #binding.pry
      substring_selections = suggestions_sorted_by_weight(word)
      substring_selections.to_a + check_library_for_similar_substrings(word.chop).to_a unless word.length.zero?
  end

  def select(substring, word)
    if library[substring].nil?
      add_substring_and_string_to_library(substring, word)
    else
      add_new_word_or_increment_wordcount(substring, word)
    end
  end

  def add_substring_and_string_to_library(substring, word)
      library[substring] = {word => 1}    
  end

  def add_new_word_or_increment_wordcount(substring, word)
    if library[substring][word]
      library[substring][word] += 1
    else
      library[substring][word] = 1 
    end
  end
  

  def suggestions_sorted_by_weight(substring)
    #binding.pry
    if library[substring]
      sorted = library[substring].sort_by {|word, val| val}.reverse
      sorted.map!{|pair| pair.first}
    end
  end

end