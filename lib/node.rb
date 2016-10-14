require 'pry'

class Node
  attr_accessor :links

  def initialize(terminal = false)
    @links = []
    @terminal = terminal
    @count = 0
  end

  def letters_array(letters)
    if letters.is_a? String
      letters.chars
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
    #binding.pry
    if letters.empty?
      add_link(first, new_terminal_node)
    elsif letter_already_inserted?(first)
      next_link(first).insert(letters)
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

  def next_link(first)
    link_of_letter(first).values.first
  end

  def link_of_letter(first)
    link = links.find {|link| link.keys[0] == first}
  end
  
  def add_link(letter, node)
    @links << {letter => node}
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