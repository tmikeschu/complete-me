require 'simplecov'
SimpleCov.start
gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'

require 'pry'

class NodeTest < Minitest::Test

  attr_reader  :root

  def setup
    @root = Node.new
  end

  def test_it_exists
    assert root
  end

  def test_it_initializes_with_empty_links_hash
    assert_equal ({}), root.links
  end

  def test_it_initializes_with_terminal_as_false
    assert_equal false, root.terminal
  end

  def test_it_turns_words_to_array
    result = root.word_characters("pizza")
    assert_equal ["p","i","z","z","a"], result
  end

  def test_it_does_nothing_with_array
    result = root.word_characters(["p","i","z","z","a"])
    assert_equal ["p","i","z","z","a"], result
  end

  def test_it_returns_nothing_if_empty_string_passed
    assert_nil root.insert("")
  end
  
  def test_it_stores_insert_in_links_hash
    assert root.links.empty?
    root.insert("b")
    assert root.links.any?
  end

  def test_it_inserts_one_letter
    root.insert("b")
    assert_equal ["b"], root.links.keys
  end

  def test_it_decides_how_to_handle_word_with_one_letter
    root.insert_decision("a", [])
    assert_equal ["a"], root.links.keys
  end

  def test_it_knows_when_to_add_links
    root.insert("b")
    root.add_link_or_flip_terminal_switch?("o")
    assert_equal ["b","o"], root.links.keys
  end

  def test_it_knows_when_to_flip_terminal_switch
    root.insert("bo")
    refute root.links["b"].terminal
    root.add_link_or_flip_terminal_switch?("b")
    assert root.links["b"].terminal
  end

  def test_it_can_add_link_and_move_to_the_next_char
    root.add_link_and_move_to_next_char("b", "o")
    assert_equal [["b"], ["o"]], [root.links.keys, root.links.values.first.links.keys]
  end

  def test_it_knows_if_character_is_not_inserted
    refute root.char_already_inserted?("a")
  end

  def test_it_inserts_two_letters
    root.insert("bo")
    second_link_letter = root.links.values.first.links.keys
    assert_equal ["o"], second_link_letter
  end

  def test_it_skips_letters_if_already_inserted
    root.insert("car")
    root.insert("carts")
    assert_equal ["c"], root.links.keys
  end

  # def test_it_flips_intermediate_switch_if_new_insert_ends_within_existing_path
  #   root = Node.new
  #   root.insert("carts")
  #   refute root.next_node("c").next_node("a").next_node("r").terminal
  #   root.insert("car")
  #   assert root.next_node("c").next_node("a").next_node("r").terminal
  # end

  # def test_it_adds_one_to_word_count_if_node_is_terminal
  #   root = Node.new
  #   refute_equal 1, root.count
  #   root.terminal = true
  #   assert_equal 1, root.count
  # end

  # def test_it_returns_word_count_of_zero_if_no_words_inserted
  #   root = Node.new
  #   assert_equal 0, root.count
  # end

  # def test_it_counts_first_inserted_word
  #   root = Node.new
  #   root.insert("car")
  #   assert_equal 1, root.count
  # end

  # def test_it_counts_second_inserted_word
  #   root = Node.new
  #   root.insert("car")
  #   root.insert("cartel")
  #   assert_equal 2, root.count
  # end 

  # def test_count_increases_with_each_insert
  #   root = Node.new
  #   root.insert("car")
  #   assert_equal 1, root.count
  #   root.insert("application")    
  #   assert_equal 2, root.count
  # end

  # def test_it_populates_newline_separated_list
  #   skip
  #   root = Node.new
  #   dictionary = File.read("/usr/share/dict/words")
  #   assert root.populate(dictionary)
  # end

  # def test_it_returns_empty_if_file_empty
  #   root = Node.new
  #   dictionary = ''
  #   assert_equal "File empty", root.populate(dictionary) 
  # end    

  # def test_it_counts_all_populated_words
  #   skip
  #   root = Node.new
  #   dictionary = File.read("/usr/share/dict/words")
  #   root.populate(dictionary)    
  #   assert_equal 235886, root.count
  # end

  # def test_it_suggests_only_word_if_empty_argument_passed
  #   root = Node.new
  #   root.insert("casts")
  #   assert_equal ["casts"], root.suggest("")
  # end

  # def test_it_suggests_intermediate_word_too_if_empty_argument_passed
  #   root = Node.new
  #   root.insert("casts")
  #   root.insert("cast")
  #   assert_equal ["cast", "casts"], root.suggest("")
  # end

  # def test_it_suggests_intermediate_words_too_if_empty_argument_passed
  #   root = Node.new
  #   root.insert("casts")
  #   root.insert("cast")
  #   root.insert("cas")
  #   assert_equal ["cas", "cast", "casts"], root.suggest("")
  # end

  # def test_it_suggests_all_of_two_words_if_no_argument_passed
  #   root = Node.new
  #   root.insert("casts")
  #   root.insert("boat")
  #   assert_equal ["boat", "casts"], root.suggest("").sort
  # end

  # def test_it_suggests_all_words_if_no_argument_passed
  #   root = Node.new
  #   root.insert("casts")
  #   root.insert("boat")
  #   root.insert("blow")
  #   root.insert("try")
  #   root.insert("tremendous")
  #   root.insert("used")
  #   root.insert("flower")
  #   suggestions = ["blow", "boat", "casts", "flower", "tremendous", "try", "used"]
  #   assert_equal suggestions, root.suggest("").sort
  # end

  # def test_suggests_nothing_if_dictionary_empty
  #   root = Node.new
  #   assert_nil root.suggest("hello")
  # end

  # def test_it_returns_message_if_argument_does_not_have_suggestions
  #   root = Node.new
  #   root.insert("casts")
  #   assert_nil root.suggest("fi")
  # end

  # def test_it_suggests_only_word_with_full_argument_as_substring
  #   root = Node.new
  #   root.insert("casts")
  #   root.insert("candy")
  #   assert_equal ["candy"], root.suggest("can")
  # end

  # def test_it_suggests_only_word_with_full_argument_as_other_substring
  #   root = Node.new
  #   root.insert("casts")
  #   root.insert("candy")
  #   assert_equal ['casts'], root.suggest("cas")
  # end

  # def test_it_suggests_argument_if_argument_is_valid_word
  #   root = Node.new
  #   root.insert("green")
  #   assert_equal ["green"], root.suggest("green")
  # end

  # def test_it_suggests_all_words_with_exact_argument_substring
  #   root = Node.new
  #   root.insert("pizza")
  #   root.insert("ploy")
  #   root.insert("pizzeria")
  #   root.insert("ivory")
  #   root.insert("pizzicato")
  #   root.insert("pizzazz")
  #   piz_words = ["pizza", 'pizzazz', 'pizzeria', "pizzicato"]
  #   assert_equal piz_words, root.suggest('piz')
  # end

  # def test_it_suggests_all_words_with_other_exact_argument_substring
  #   root = Node.new
  #   root.insert("pizza")
  #   root.insert("ploy")
  #   root.insert("pizzeria")
  #   root.insert("ivory")
  #   root.insert("pizzicato")
  #   root.insert("pizzazz")
  #   piz_words = ["pizza", 'pizzazz', 'pizzeria', "pizzicato"]
  #   assert_equal piz_words.first(2), root.suggest("pizza")
  # end


end