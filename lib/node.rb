require 'pry'

class Node
  attr_accessor :links,
                :terminal

  def initialize(terminal = false)
    @links = []
    @terminal = terminal
  end

  def letters_array(letters)
    if letters.is_a? String
      letters.downcase.chars
    else
      letters
    end
  end

  def insert(letters)
    letters = letters_array(letters)
    first   = letters.shift
    insert_decision(first, letters)
  end
  
  def insert_decision(first, letters)
    if letters.empty?
      add_link_or_flip_terminal_switch?(first)
    elsif letter_already_inserted?(first)
      next_node(first).insert(letters)
    else
      add_link_and_move_to_next_letter(first, letters)
    end
  end

  def letter_already_inserted?(first)
    if links.any?
      already_inserted_letters.include?(first)
    else
      false
    end
  end

  def already_inserted_letters
    inserted_letters = links.map { |link| link.keys}.flatten
  end

  def next_node(first)
    #binding.pry
    link_of_letter(first).values.first
  end

  def link_of_letter(first)
    links.find {|link| link.keys[0] == first}
  end
  
  def add_link_or_flip_terminal_switch?(first)
    #binding.pry
    if letter_already_inserted?(first)
      link_of_letter(first).values.first.terminal = true
    else
      @links << {first => new_terminal_node}
    end

  end

  
  def new_terminal_node 
    Node.new(terminal = true)
  end

  def add_link_and_move_to_next_letter(first, letters)
      new_node = Node.new
      @links << {first => new_node}
      new_node.insert(letters)
  end
end