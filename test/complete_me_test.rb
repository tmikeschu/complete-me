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

  def test_returns_seggestion_for_substring
    completion.insert("pizza")
    completion.insert("pizzaria")
    completion.insert("book")
    suggestion = completion.suggest("piz")
    assert_equal ["pizza", "pizzaria"], suggestion
  end
  
end