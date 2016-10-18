require 'simplecov'
SimpleCov.start
gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'

require 'pry'

class CompleteMeTest < Minitest::Test

  attr_reader   :completion

  def setup
    @completion = CompleteMe.new
  end

  def test_it_exists
    assert completion
  end

  def test_it_root_node_exist
    assert completion.root
  end

  def test_it_root_class_is_node
    assert_equal Node, completion.root.class
  end

  def test_it_insert_returns_last_letter_of_word
    assert_equal "a", completion.insert("pizza").first.keys.first
  end

  def test_it_count_returns_total_words
    completion.insert("pizza")
    assert_equal 1, completion.count
  end

  def test_populate_from_file
    skip
    dictionary = File.read("/usr/share/dict/words")
    result = completion.populate(dictionary)
    assert_equal 235886, result.count
  end

  def test_returns_suggestion_for_substring
    completion.insert("pizza")
    completion.insert("pizzaria")
    completion.insert("book")
    suggestion = completion.suggest("piz")
    assert_equal ["pizza", "pizzaria"], suggestion
  end

  def test_it_initializes_with_empty_library
    assert completion.library.empty?
  end

  def test_select_adds_hash_to_library
    completion.select("com", "computer")
    assert_equal ({"computer" => 1}), completion.library["com"]   
  end  
  
  def test_selecting_increases_word_weight_for_substring_key
    completion.select("com", "computer")
    assert_equal ({"computer" => 1}), completion.library["com"]
    completion.select("com", "computer")
    assert_equal ({"computer" => 2}), completion.library["com"]
  end 

  def test_set_new_hash_adds_substring_pointing_to_word_and_count_hash_in_library
    completion.add_substring_and_string_to_library("com", "computer")
    assert_equal ({"computer" => 1}), completion.library["com"]       
  end

  def test_it_knows_how_to_add_word_or_increase_word_count_in_existing_substring_in_library
    completion.select("com", "computer")
    completion.add_new_word_or_increment_wordcount("com", "computer")
    assert_equal ({"computer" => 2}), completion.library["com"]
  end

  def test_it_can_sort_substring_values_by_weight 
    completion.select("com", "coming")  
    completion.select("com", "computer")
    completion.select("com", "computer")
    assert_equal ["computer", "coming"], completion.suggestions_sorted_by_weight("com")
  end

  def test_suggest_returns_library_hash_values_if_substring_in_library
    completion.select("com", "coming")  
    completion.select("com", "computer")
    completion.select("com", "computer")
    assert_equal ["computer", "coming"], completion.suggest("com")
  end

  def test_suggest_returns_library_hash_values_and_other_trie_suggestions_after
    completion.insert("commuter")
    completion.select("com", "coming")  
    completion.select("com", "computer")
    completion.select("com", "computer")
    assert_equal ["computer", "coming"], completion.suggest("com")
  end

  def test_it_appends_weighted_words_of_substring_with_one_less_character
    completion.select("piz", "pizzeria")
    completion.select("piz", "pizzeria")
    completion.select("piz", "pizzeria")
    completion.select("pi", "pizza")
    completion.select("pi", "pizza")
    completion.select("pi", "pizzicato")
    assert_equal ["pizzeria", "pizza", "pizzicato"], completion.suggest("piz")    
  end
  def test_it_appends_weighted_words_of_substring_with_multiple_less_characters
    completion.select("piz", "pizzeria")
    completion.select("piz", "pizzeria")
    completion.select("piz", "pizzeria")
    completion.select("pi", "pizza")
    completion.select("pi", "pizza")
    completion.select("p", "pizzle")
    assert_equal ["pizzeria", "pizza", "pizzle"], completion.suggest("piz")    
  end

  def test_it_appends_weighted_words_of_substring_with_one_more_character
  end
end