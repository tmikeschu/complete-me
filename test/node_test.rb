gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'
require 'pry'

class NodeTest < Minitest::Test

  def test_it_exists
    assert Node.new
  end

  def test_it_inserts_one_letter
    root = Node.new
    root.insert("b")
    root_link = root.links.first.keys
    assert_equal ["b"], root_link
  end

  def test_it_inserts_two_letters
    root = Node.new
    root.insert("bo")
    second_link = root.links.first.values.first.links.first.keys
    assert_equal ["o"], second_link
  end

  def test_it_skips_prefix_letters_if_already_inserted
    binding.pry
    root = Node.new
    root.insert("car")
    root.insert("carts")
    root.insert("casted")
    root.insert("bust")
    root.insert("busted")
    root.insert("flower")    
    #assert that keys are different and unique
  end


  
end