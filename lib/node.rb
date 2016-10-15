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
      keys.downcase.chars
    else
      keys
    end
  end

  def insert(keys)
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
end