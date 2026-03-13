require_relative '../src/lib/term'
require 'minitest/autorun'

class TermTestInitializeCompound < Minitest::Test # полное покрыттие html реализоватьь
  def test_basic_with_no_pow
    assert_equal "46x", Term.new('46x').to_s
  end
  def test_basic_with_pow
    assert_equal "y^4", Term.new('y^4').to_s
  end
  def test_basic_with_pow_and_mult
    assert_equal "-486z^10", Term.new('3z^2').pow(5).mult(-2).to_s
  end
  def test_diff_basic
    assert_equal "6x", Term.new('3x^2').diff("x").to_s
  end
  def test_diff_only_mult 
    assert_equal "-3", Term.new('-3x').diff("x").to_s
  end
  def test_diff_only_pow
    assert_equal "4x^3", Term.new('x^4').diff("x").to_s
  end
  def test_diff_only_negative_pow
    assert_equal "-4x^-5", Term.new('x^-4').diff("x").to_s
  end
  def test_diff_const
    assert_equal "1", Term.new('x').diff("x").to_s
  end
  def test_diff_negative_const
    assert_equal "-1", Term.new('-x').diff("x").to_s
  end
end
class TermTestInitializeBasic < Minitest::Test
  def test_basic_with_no_pow
    assert_equal "46x", Term.new('x').mult(23).mult(2).to_s
  end
  def test_basic_with_pow
    assert_equal "y^4", Term.new('y').pow(2).pow(2).to_s
  end
  def test_basic_with_pow_and_mult
    assert_equal "-486z^10", Term.new('z').pow(2).mult(3).pow(5).mult(-2).to_s
  end
  def test_diff_basic
    assert_equal "6x", Term.new('x').pow(2).mult(3).diff("x").to_s
  end
  def test_diff_only_mult
    assert_equal "-3", Term.new('x').mult(-3).diff("x").to_s
  end
  def test_diff_only_pow
    assert_equal "4x^3", Term.new('x').pow(4).diff("x").to_s
  end
  def test_diff_only_negative_pow
    assert_equal "-4x^-5", Term.new('x').pow(-4).diff("x").to_s
  end
  def test_diff_const
    assert_equal "1", Term.new('x').diff("x").to_s
  end
  def test_diff_negative_const
    assert_equal "-1", Term.new('x').mult(-1).diff("x").to_s
  end
end