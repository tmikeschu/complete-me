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
      (suggestions_sorted_by_weight(word) + root.suggest(word).to_a).uniq
    else
      root.suggest(word)
    end
  end

  def select(substring, word)
    if library[substring].nil?
      add_substring_with_word_to_library(substring, word)
    else
      add_new_word_or_increment_wordcount(substring, word)
    end
  end

  def add_substring_with_word_to_library(substring, word)
    library[substring] = {word => 1}    
  end

  def add_new_word_or_increment_wordcount(substring, word)
    if library[substring][word]
       library[substring][word] += 1
    else
       library[substring][word]  = 1 
    end
  end

  def suggestions_sorted_by_weight(substring)
    sorted = library[substring].sort_by {|word, val| val}.reverse
    retreive_words_from_word_weight_list(sorted)
  end
 
  def retreive_words_from_word_weight_list(sorted)
    sorted.map{|word_weight_pair| word_weight_pair.first}
  end
  
end