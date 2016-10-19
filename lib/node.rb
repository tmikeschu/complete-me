require 'pry'
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
    return if word.to_s.empty? or word.nil?
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
      word_count += links.values.map { |node| node.count }.reduce(:+)
    end
    word_count 
  end

  def populate(converted_file)
    if converted_file.empty?
      "File empty"
    else
      if converted_file.is_a? String
        files_lines = converted_file.split
      else
        files_lines = converted_file
      end 
      files_lines.each { |line| insert(line) }
    end
  end

  def suggest(word = "")
    characters = word_characters(word)
    if characters.empty?
      gather_suggestions(word)
    else
      go_to_node_of_substring_end(word, characters)
    end
  end
  
  def go_to_node_of_substring_end(word, characters)
    first_char = characters.shift 
    if characters.empty?
      # binding.pry
      empty_char_decision(first_char, word)
    elsif char_already_inserted?(first_char)
      links[first_char].go_to_node_of_substring_end(word, characters)
    end
  end

  def empty_char_decision(first_char, word)
    # binding.pry
    if char_already_inserted?(first_char)
      links[first_char].gather_suggestions(word) 
      # binding.pry
    end
  end

  def gather_suggestions(word)
    suggestions = []
    if leaf?
      suggestions << word
    else
      add_words_to_suggestions(word, suggestions)
    end
    # binding.pry
    suggestions.flatten
  end

  def add_words_to_suggestions(word, suggestions) 
    if links.any? 
      suggestions << collect_words(word)
    end
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