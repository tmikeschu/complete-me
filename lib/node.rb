require 'pry'

class Node
  attr_accessor :links,
                :terminal,
                :frequent_picks

  def initialize(terminal = false)
    @links          = []
    @frequent_picks = []
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
    return nil if keys.nil? or keys.empty?
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
    inserted_keys = links.map { |link| link.keys}.flatten
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

  def populate(file)
    if file.empty?
      "File empty"
    else
      files_lines = file.split
      files_lines.each { |line| insert(line) }
    end
  end

  def suggest(word = "")
    keys = keys_array(word)
    if keys.empty?
      traverse_links(word)
    else
      suggestions = go_to_node_of_substring_end(word, keys)
    end
    weight_assessment(word, suggestions)
    suggestions
  end

  def weight_assessment(word, suggestions)
    binding.pry
    frequent_substrings = frequent_picks.map {|hot_item| letter_of(hot_item)}
    if frequent_substrings.include?(word)
      frequent_pick = suggestions.find {|suggestion| suggestion == frequent_picks.find {|pick| pick.keys.first == word}.values.first}
    
    else
      suggestions
    end
  end
  
  def go_to_node_of_substring_end(word, keys)
    first_key = keys.shift 
    if keys.empty?
      empty_key_decision(first_key, word)
    elsif key_already_inserted?(first_key)
      next_node(first_key).go_to_node_of_substring_end(word, keys)
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
    suggestions << word if leaf? or intermediate_word?
    add_words_to_suggestions(word, suggestions)
    suggestions.flatten
  end

  def add_words_to_suggestions(word, suggestions) 
    if links.any? 
      links.each do |link|
        suggestions << node_of(link).collect_words(word, link)
      end
    end
  end

  def collect_words(word, words = [], link)
    word  += letter_of(link)
    words << word if intermediate_word?
    words << word if leaf?
    node_of(link).links.each {|link| node_of(link).collect_words(word, words, link)}
    words
  end

  def leaf?
    terminal && links.empty?
  end

  def intermediate_word?
    terminal && links.any?
  end

  def select(substring, choice)
    frequent_picks << {substring => choice}
  end

end