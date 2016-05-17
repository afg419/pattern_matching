require_relative '../lib/pattern_matching'
require 'minitest/autorun'

class PatternMatchingTest < Minitest::Test
  include PatternMatching

  def test_exists
    assert PatternMatching
  end

  def test_ids_legal_variable_names
    assert legal_matcher?("x")
    assert legal_matcher?("x1")
    assert legal_matcher?("_x1")
    assert legal_matcher?(:a)
    assert legal_matcher?(:a1)

    refute legal_matcher?(:A)
    refute legal_matcher?("A")
    refute legal_matcher?("he?y")
    refute legal_matcher?("a b")
  end

  def test_matches_integer
    pm("a", 2)
    assert_equal 2, @a
    @a = nil
  end

  def test_matches_with_symbol_matcher
    pm(:a, 2)
    assert_equal 2, @a
    @a = nil
  end

  def test_matches_float
    pm("a", 2.0)
    assert_equal 2.0, @a
    @a = nil
  end

  def test_matches_string
    pm("a", "hello dear")
    assert_equal "hello dear", @a
    @a = nil
  end

  def test_matches_symbol
    pm("a", :x)
    assert_equal :x, @a
    @a = nil
  end

  def test_matches_boolean
    pm("a", true)
    assert_equal true, @a
    @a = nil
  end

  def test_matches_array
    pm("a", [1,2])
    assert_equal [1,2], @a
    @a = nil
  end

  def test_matches_hash
    pm("a", {x: 2})
    assert_equal( {x: 2}, @a )
    @a = nil
  end

  def test_matches_integer_array
    pm(["a", "b"], [1,2])
    assert_equal 1, @a
    assert_equal 2, @b
    @a, @b = [nil, nil]
  end

  def test_matches_string_array
    pm(["a", "b"], ["hello dear", "ten"])
    assert_equal "hello dear", @a
    assert_equal "ten", @b
    @a, @b = [nil, nil]
  end


  def test_matches_mixed_array
    pm(["a", "b"], ["hello dear", 10])
    assert_equal "hello dear", @a
    assert_equal 10, @b
    @a, @b = [nil, nil]
  end

  def test_matches_hashes_string_keys
    pm({"a" => "b"}, {"x" => 5})
    assert_equal "x", @a
    assert_equal 5, @b
    @a, @b = [nil, nil]
  end

  def test_matches_hashes_symbol_key_matcher
    pm({a: "b"}, {"x" => 5})
    assert_equal "x", @a
    assert_equal 5, @b
    @a, @b = [nil, nil]
  end

  def test_matches_hashes_symbol_key_expression
    pm({a: "b"}, {x: 5})
    assert_equal :x, @a
    assert_equal 5, @b
    @a, @b = [nil, nil]
  end

  def test_matches_mixed_enumerables1
    pm({"a" => ["b", "c"]}, {x: [3, 4]})
    assert_equal :x, @a
    assert_equal 3, @b
    assert_equal 4, @c
    @a, @b, @c = [nil, nil, nil]
  end

  def test_matches_mixed_enumerables2
    pm(["a", {b: "c"}], [3, {"hey" => 10}])
    assert_equal 3, @a
    assert_equal "hey", @b
    assert_equal 10, @c
    @a, @b, @c = [nil, nil, nil]
  end

  def test_matches_variable_specificity
    pm(["a", "b"], [3, {"hey" => 10}])
    assert_equal 3, @a
    assert_equal({"hey" => 10}, @b )
    @a, @b = [nil, nil]
  end

  def test_throws_illegal_matcher
    assert_raises(IllegalMatcherError) do
      pm(5, 6)
    end

    assert_raises(IllegalMatcherError) do
      pm([3,"a"], [2,3])
    end

    assert_raises(IllegalMatcherError) do
      pm(["a",true], [2,3])
    end

    assert_raises(IllegalMatcherError) do
      pm({3 => "a"}, {x: 4})
    end

    assert_raises(IllegalMatcherError) do
      pm({"a" => 4}, {x: 4})
    end
  end

  def test_throws_no_match_possible
    assert_raises(NoPossibleMatchError) do
      pm(["a", "b"], [1,2,3])
    end

    assert_raises(NoPossibleMatchError) do
      pm({"a" => "b"}, [1])
    end

    assert_raises(NoPossibleMatchError) do
      pm({"a" => "b"}, {x:1, y: 2})
    end

    assert_raises(NoPossibleMatchError) do
      pm({}, {a: 1})
    end
  end
end
