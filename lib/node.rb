require 'pry'

class Node
  attr_accessor :links,
                :terminal
                
  def initialize(terminal = false)
    @links          = []
    @terminal       = terminal
  end

  def keys_array(keys)
    if keys.is_a? String
      keys.chars
    else
      keys
    end
  end

  def node_of(link)
    link.values.first
  end

  def letter_of(link)
    link.keys.first
  end

  def insert(keys)
     keys        = keys_array(keys)
    first_key   = keys.shift
    insert_decision(first_key, keys)
  end
  
  def insert_decision(first_key, keys)
    if keys.empty?
      add_link_or_flip_terminal_switch?(first_key)
    elsif key_already_inserted?(first_key)
      next_node(first_key).insert(keys)
    else
      add_link_and_move_to_next_key(first_key, keys)
    end
  end

  def key_already_inserted?(first_key)
    if links.any?
      already_inserted_keys.include?(first_key)
    else
      false
    end
  end

  def already_inserted_keys
    inserted_keys = links.map { |link| letter_of(link)}
  end

  def next_node(first_key)
    node_of(link_of_key(first_key))
  end

  def link_of_key(first_key)
    links.find { |link| letter_of(link) == first_key }
  end
  
  def add_link_or_flip_terminal_switch?(first_key)
    if key_already_inserted?(first_key)
      node_of(link_of_key(first_key)).terminal = true
    else
      @links << { first_key => new_terminal_node }
    end
  end

  def new_terminal_node 
    Node.new(terminal = true)
  end

  def add_link_and_move_to_next_key(first_key, keys)
      new_node = Node.new
      @links << { first_key => new_node }
      new_node.insert(keys)
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
    keys = keys_array(word)
    if keys.empty?
      traverse_links(word)
    else
      go_to_node_of_substring_end(word, keys)
    end
  end

 
  
  def go_to_node_of_substring_end(word, keys)
    #binding.pry 
    first_key = keys.shift 
    if keys.empty?
      empty_key_decision(first_key, word)
    elsif key_already_inserted?(first_key)
      next_node(first_key).go_to_node_of_substring_end(word, keys)
    else
    end
  end

  def empty_key_decision(first_key, word) 
    if key_already_inserted?(first_key)
      next_node(first_key).traverse_links(word)
    else 
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