require 'pry'

class Node
  attr_accessor :links,
                :terminal

  def initialize(terminal = false)
    @links = []
    @terminal = terminal
  end

  def keys_array(keys)
    if keys.is_a? String
      keys.chars
    else
      keys
    end
  end

  def leaf?
    terminal && links.empty?
  end

  def intermediate_word?
    terminal && links.any?
  end

  def insert(keys)
    return if keys.nil? or keys.empty?
    keys = keys_array(keys)
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
    inserted_keys = links.map { |link| link.keys}.flatten
  end

  def next_node(first_key)
    link_of_key(first_key).values.first
  end

  def link_of_key(first_key)
    links.find {|link| link.keys[0] == first_key}
  end
  
  def add_link_or_flip_terminal_switch?(first_key)
    if key_already_inserted?(first_key)
      link_of_key(first_key).values.first.terminal = true
    else
      @links << {first_key => new_terminal_node}
    end
  end

  def new_terminal_node 
    Node.new(terminal = true)
  end

  def add_link_and_move_to_next_key(first_key, keys)
      new_node = Node.new
      @links << {first_key => new_node}
      new_node.insert(keys)
  end

  def count
    word_count = 0
    word_count += 1 if terminal
    if links.any?
      word_count += links.map {|link| link.values.first.count}.reduce(:+)
    end
    word_count 
  end

  def populate(file)
    if file.empty?
      "File empty"
    else
      files_lines = file.split
      files_lines.each { |line| insert(line) }
    end
  end

  def suggest(word = "")
    #binding.pry
    keys = keys_array(word)
    go_to_node_of_prefix_end(word, keys)
  end
  
  def go_to_node_of_prefix_end(word, keys)
    first_key = keys.shift
    if first_key.nil?
      traverse_links(word)
    elsif keys.empty?
      empty_key_decision(first_key, word)
    elsif key_already_inserted?(first_key)
      next_node(first_key).go_to_node_of_prefix_end(word, keys)
    else
      "There are no words to suggest"      
    end
  end

  def empty_key_decision(first_key, word)
    if key_already_inserted?(first_key)
      next_node(first_key).traverse_links(word)
    else 
      "There are no words to suggest"
    end
  end

  def traverse_links(word)
    suggestions = []
    if links.any? 
     links.each {|link| suggestions << collect_words(word, link)}
    end
    suggestions.flatten.sort
  end
  
  def collect_words(word, words = [], link)
    #binding.pry
    word += link.keys.first
    add_leaf?(word, words)
    add_intermediate_word?(word, words)
    link.values.first.links.each {|link| link.values.first.collect_words(word, words, link)}.compact.flatten
    words
  end

  def add_leaf?(word, words)
    if leaf?
      words << word
      words.compact
    end
  end

  def add_intermediate_word?(word, words)
    words << word if intermediate_word?
  end


end