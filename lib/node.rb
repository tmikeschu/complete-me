require 'csv'

class Node
  attr_accessor :links,
                :terminal
                
  def initialize(terminal = false)
    @links          = {}
    @terminal       = terminal
  end

  def word_characters(word)
    if word.is_a? String
      word.chars
    else
      word
    end
  end

  def insert(word)
    word = word.to_s if word.is_a? Integer
    return if word.empty? or word.nil?
    characters = word_characters(word)
    insert_decision(characters.shift, characters)
  end
  
  def insert_decision(first_char, characters)
    if characters.empty?
      add_link_or_flip_terminal_switch?(first_char)
    elsif char_already_inserted?(first_char)
      links[first_char].insert(characters)
    else
      add_link_and_move_to_next_char(first_char, characters)
    end
  end

  def char_already_inserted?(first_char)
    if links.any?
      links.keys.include?(first_char)
    else
      false
    end
  end
  
  def add_link_or_flip_terminal_switch?(first_char)
    if char_already_inserted?(first_char)
      links[first_char].terminal = true
    else
      @links[first_char] = new_terminal_node
    end
  end

  def new_terminal_node 
    Node.new(terminal = true)
  end

  def add_link_and_move_to_next_char(first_char, characters)
      new_node = Node.new
      @links[first_char] = new_node
      new_node.insert(characters)
  end

  def count
    word_count  = 0
    word_count += 1 if terminal
    if links.any?
      links.each_value {|node| word_count += node.count}
    end
    word_count 
  end

  def populate(file)
    if file
      file_lines = convert_file_to_array_if_string(file)
      insert_file_lines(file_lines)
    end
  end

  def convert_file_to_array_if_string(file)
    file.split if file.is_a? String
  end

  def insert_file_lines(file)
    file.each { |line| insert(line) }
  end

  def suggest(word = "")
    characters = word_characters(word)
    decide_if_characters_empty(word, characters)
  end

  def decide_if_characters_empty(word, characters)
    if characters.empty?
      gather_suggestions(word)
    else
      go_to_node_of_substring_end(word, characters)
    end
  end
  
  def go_to_node_of_substring_end(word, characters)
    first_char = characters.shift 
    if characters.empty?
      empty_char_decision(first_char, word)
    elsif char_already_inserted?(first_char)
      links[first_char].go_to_node_of_substring_end(word, characters)
    end
  end

  def empty_char_decision(first_char, word)
    if char_already_inserted?(first_char)
      links[first_char].gather_suggestions(word) 
    end
  end

  def gather_suggestions(word)
    suggestions = []
    decide_if_leaf(suggestions, word)
    suggestions.flatten
  end

  def decide_if_leaf(suggestions, word)
    if leaf?
      suggestions << word
    else
      add_words_to_suggestions(word, suggestions)
    end
  end

  def add_words_to_suggestions(word, suggestions) 
    suggestions << collect_words(word) if links.any? 
  end

  def collect_words(word, words = [], letter = "") 
    word  += letter
    words << word if intermediate_word? or leaf? 
    links.each {|letter, node| node.collect_words(word, words, letter)}
    words
  end

  def leaf?
    terminal && links.empty?
  end

  def intermediate_word?
    terminal && links.any?
  end

end