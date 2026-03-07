require_relative '../src/lib/symbol'
require 'minitest/autorun'

class TermTest < Minitest::Test
  def test_basic_with_no_pow
    assert_equal Term.new('x').mult(23).mult(2).to_s, "46x" 
  end
  def test_basic_with_pow
    assert_equal Term.new('y').pow(2).pow(2).to_s, "y^4"
  end
  def test_basic_with_pow_and_mult
    assert_equal Term.new('z').pow(2).mult(3).pow(5).mult(-2).to_s, "-486z^10"
  end
  def test_diff_basic
    assert_equal Term.new('x').pow(2).mult(3).diff.to_s, "6x"
  end
  def test_diff_only_mult 
    assert_equal Term.new('x').mult(-3).diff.to_s, "-3"
  end
  def test_diff_only_pow
    assert_equal Term.new('x').pow(4).diff.to_s, "4x^3"
  end
  def test_diff_only_negative_pow
    assert_equal Term.new('x').pow(-4).diff.to_s, "-4x^-5"
  end
  def test_diff_const
    assert_equal Term.new('x').diff.to_s, "1"
  end
  def test_diff_negative_const
    assert_equal Term.new('x').mult(-1).diff.to_s, "-1"
  end
end