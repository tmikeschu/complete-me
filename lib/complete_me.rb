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
      generate_weighted_list_of_suggestions(word)
    else
      root.suggest(word)
    end
  end

  def generate_weighted_list_of_suggestions(substring)
    similar = weighted_list_of_similar_substrings(similar_substrings(substring))
    suggestions_sorted_by_weight(substring) + similar
  end

  def similar_substrings(substring)
    library.keys.find_all {|sub| sub[0] == substring[0]} - [substring]
  end

  def weighted_list_of_similar_substrings(similar_substrings)
    similar_substrings.map {|substring| suggestions_sorted_by_weight(substring)}.flatten
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
    if library[substring]
      sorted = library[substring].sort_by {|word, val| val}.reverse
      sorted.map!{|pair| pair.first}
    end
  end

end