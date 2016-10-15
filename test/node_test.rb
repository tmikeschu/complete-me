gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'
require 'pry'

class NodeTest < Minitest::Test

  def test_it_exists
    assert Node.new
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

end