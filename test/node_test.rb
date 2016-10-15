gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'
require 'pry'

class NodeTest < Minitest::Test

  def test_it_exists
    assert Node.new
  end

  def test_it_returns_nothing_if_empty_key_inserted
    root = Node.new
    refute root.insert("")
  end

  def test_it_inserts_one_key
    root = Node.new
    root.insert("b")
    root_link = root.links.first.keys
    assert_equal ["b"], root_link
  end

  def test_it_inserts_two_keys
    root = Node.new
    root.insert("bo")
    second_link = root.links.first.values.first.links.first.keys
    assert_equal ["o"], second_link
  end

  def test_it_skips_prefix_keys_if_already_inserted
    #binding.pry
    root = Node.new
    root.insert("car")
    root.insert("carts")
    links = root.links.map {|link| link.keys}
    uniqs = links.uniq
    assert_equal links, uniqs
  end

  def test_it_flips_intermediate_switch_if_new_insert_ends_within_existing_path
    root = Node.new
    root.insert("carts")
    refute root.next_node("c").next_node("a").next_node("r").terminal
    root.insert("car")
    assert root.next_node("c").next_node("a").next_node("r").terminal
  end

  def test_it_adds_one_to_word_count_if_node_is_terminal
    root = Node.new
    refute_equal 1, root.count
    root.terminal = true
    assert_equal 1, root.count
  end

  def test_it_returns_word_count_of_zero_if_no_words_inserted
    root = Node.new
    assert_equal 0, root.count
  end

  def test_it_counts_first_inserted_word
    root = Node.new
    root.insert("car")
    assert_equal 1, root.count
  end

  def test_it_counts_second_inserted_word
    root = Node.new
    root.insert("car")
    root.insert("cartel")
    #binding.pry
    assert_equal 2, root.count
  end 

  def test_it_populates_newline_separated_list
    skip
    root = Node.new
    dictionary = File.read("/usr/share/dict/words")
    assert root.populate(dictionary)
  end

  def test_it_returns_empty_if_file_empty
    root = Node.new
    dictionary = ''
    assert_equal "File empty", root.populate(dictionary) 
  end    

  def test_it_counts_all_populated_words
    skip
    root = Node.new
    dictionary = File.read("/usr/share/dict/words")
    root.populate(dictionary)    
    assert_equal 235886, root.count
  end

  def test_it_suggests_all_words_for_empty_suggest_argument
    root = Node.new
    root.insert("carts")
    root.insert("cast")
    assert_equal ["carts", "cast"], root.suggest("")
  end

end