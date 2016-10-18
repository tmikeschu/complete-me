require 'pry'

class Node
  attr_accessor :links,
                :terminal
                
  def initialize(terminal = false)
    @links          = []
    @terminal       = terminal
  end

  def word_characters(word)
    if word.is_a? String
      word.chars
    else
      word
    end
  end

  def node_of(link)
    link.values.first
  end

  def letter_of(link)
    link.keys.first
  end

  def insert(word)
    return if word.empty? or word.nil?
    characters = word_characters(word)
    insert_decision(characters.shift, characters)
  end
  
  def insert_decision(first_char, characters)
    if characters.empty?
      add_link_or_flip_terminal_switch?(first_char)
    elsif char_already_inserted?(first_char)
      next_node(first_char).insert(characters)
    else
      add_link_and_move_to_next_char(first_char, characters)
    end
  end

  def char_already_inserted?(first_char)
    if links.any?
      already_inserted_characters.include?(first_char)
    else
      false
    end
  end

  def already_inserted_characters
    links.map { |link| letter_of(link)}
  end

  def next_node(first_char)
    node_of(link_of_char(first_char))
  end

  def link_of_char(first_char)
    links.find { |link| letter_of(link) == first_char }
  end
  
  def add_link_or_flip_terminal_switch?(first_char)
    if char_already_inserted?(first_char)
      next_node(first_char).terminal = true
    else
      @links << { first_char => new_terminal_node }
    end
  end

  def new_terminal_node 
    Node.new(terminal = true)
  end

  def add_link_and_move_to_next_char(first_char, characters)
      new_node = Node.new
      @links << { first_char => new_node }
      new_node.insert(characters)
  end

  def count
    word_count  = 0
    word_count += 1 if terminal
    if links.any?
      word_count += links.map { |link| node_of(link).count }.reduce(:+)
    end
    word_count 
  end

  def populate(converted_file)
    if converted_file.empty?
      "File empty"
    else
      files_lines = converted_file.split
      files_lines.each { |line| insert(line) }
    end
  end

  def suggest(word = "")
    #binding.pry 
    characters = word_characters(word)
    if characters.empty?
      traverse_links(word)
    else
      go_to_node_of_substring_end(word, characters)
    end
  end

 
  
  def go_to_node_of_substring_end(word, characters)
    #binding.pry 
    first_char = characters.shift 
    if characters.empty?
      empty_char_decision(first_char, word)
    elsif char_already_inserted?(first_char)
      next_node(first_char).go_to_node_of_substring_end(word, characters)
    end
  end

  def empty_char_decision(first_char, word) 
    if char_already_inserted?(first_char)
      next_node(first_char).traverse_links(word) 
    end
  end

  def traverse_links(word)
    suggestions = []
    if leaf?
      suggestions << word
    else
      add_words_to_suggestions(word, suggestions)
    end
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
    links.each {|link| node_of(link).collect_words(word, words, letter_of(link))}
    words
  end

  def leaf?
    terminal && links.empty?
  end

  def intermediate_word?
    terminal && links.any?
  end


end