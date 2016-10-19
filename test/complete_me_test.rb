require 'simplecov'
SimpleCov.start
gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/complete_me'
require 'pry'

class CompleteMeTest < Minitest::Test

  attr_reader   :completion

  def setup
    @completion = CompleteMe.new
  end

  def test_it_exists
    assert completion
  end

  def test_it_initializes_with_empty_library
    assert completion.library.empty?
  end
  
  def test_library_is_a_hash
    assert_equal Hash, completion.library.class
  end

  def test_it_has_root
    assert completion.root
  end

  def test_root_is_a_node_object
    assert_equal Node, completion.root.class
  end

  def test_uniq_insert_returns_a_node_with_no_links
    result = completion.insert("pizza").links
    assert_equal ({}), result 
  end

  def test_count_returns_total_words
    completion.insert("pizza")
    assert_equal 1, completion.count
  end

  def test_it_populates_from_file
    # skip
    dictionary = File.read("/usr/share/dict/words")
    result = completion.populate(dictionary)
    assert_equal 235886, result.count
  end

  def test_it_populates_addresses_from_csv
    # skip
    addresses = CSV.read('addresses.csv')
    addresses = addresses.map {|row| row [-1]}
    addresses.shift
    completion.populate(addresses)
    #binding.pry
    assert_equal 293605, completion.count
  end

  def test_it_returns_suggestion_for_substring
    completion.insert("pizza")
    completion.insert("pizzaria")
    completion.insert("book")
    suggestion = completion.suggest("piz")
    assert_equal ["pizza", "pizzaria"], suggestion
  end

  def test_select_adds_hash_to_library
    completion.select("com", "computer")
    assert_equal ({"computer" => 1}), completion.library["com"]   
  end  
  
  def test_selecting_increases_word_weight_for_substring_key
    completion.select("com", "computer")
    completion.select("com", "computer")
    assert_equal ({"computer" => 2}), completion.library["com"]
  end 

  def test_set_new_hash_adds_substring_pointing_to_word_and_count_hash_in_library
    completion.add_substring_with_word_to_library("com", "computer")
    assert_equal ({"computer" => 1}), completion.library["com"]       
  end

  def test_it_knows_when_to_add_word_to_library_if_substring_exists
    completion.select("com", "comment")
    completion.add_new_word_or_increment_wordcount("com", "computer")
    assert_equal ({"comment" => 1, "computer" => 1}), completion.library["com"]
  end

  def test_it_knows_when_to_increase_word_count_in_existing_substring
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

  def test_it_retrieves_words_from_word_weight_pair_arrays
    sorted = [["hey", 3],["what", 1]]
    result = completion.retreive_words_from_word_weight_list(sorted)
    assert_equal ["hey", "what"], result
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
    assert_equal ["computer", "coming","commuter"], completion.suggest("com")
  end

  def test_suggest_returns_one_library_hash_value_and_other_trie_suggestion_from_dictionary
    # skip
    dictionary = File.read("/usr/share/dict/words")
    result = completion.populate(dictionary)
    completion.select("piz", "pizzeria")
    assert_equal ["pizzeria", "pize", "pizza", "pizzicato", "pizzle"],completion.suggest("piz")
  end
  
  def test_suggest_returns_two_library_hash_values_and_other_trie_suggestion_from_dictionary
    # skip
    dictionary = File.read("/usr/share/dict/words")
    result = completion.populate(dictionary)
    completion.select("piz", "pizzle")
    completion.select("piz", "pizzeria")
    assert_equal ["pizzeria", "pizzle", "pize", "pizza", "pizzicato"], completion.suggest("piz")
  end

end