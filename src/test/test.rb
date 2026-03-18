
require_relative 'test_helper'
require_relative '../lib/term'
require_relative '../lib/expr'

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
class ExprTest < Minitest::Test
  def test_initialize_with_terms
    expr = Expr.new(Term.new('x'), Term.new('2y'))
    assert_equal 'x + 2y', expr.to_s
  end

  def test_initialize_with_string_simple
    expr = Expr.new('x + 2y')
    assert_equal 'x + 2y', expr.to_s
  end

  def test_initialize_with_string_spaces
    expr = Expr.new('  x  - 3x^2  + 5 ')
    assert_equal 'x - 3x^2 + 5', expr.to_s
  end

  def test_initialize_with_string_negative_first
    expr = Expr.new('-x + 2y')
    assert_equal '-x + 2y', expr.to_s
  end

  def test_initialize_with_string_only_constant
    expr = Expr.new('42')
    assert_equal '42', expr.to_s
  end

  def test_initialize_with_string_negative_constant
    expr = Expr.new('-7')
    assert_equal '-7', expr.to_s
  end

  def test_initialize_with_string_zero_constant
    expr = Expr.new('0')
    assert_equal '0', expr.to_s
  end

  def test_initialize_with_string_zero_term
    expr = Expr.new('0x + y')
    # Term.new('0x') даст множитель 0 → to_s = '0'
    assert_equal '0 + y', expr.to_s
  end

  def test_initialize_with_string_negative_power
    expr = Expr.new('x^-2 + 3y')
    assert_equal 'x^-2 + 3y', expr.to_s
  end

  def test_initialize_empty_string
    expr = Expr.new('')
    assert_equal '0', expr.to_s
  end

  def test_initialize_with_array
    expr = Expr.new([Term.new('x'), Term.new('y')])
    assert_equal 'x + y', expr.to_s
  end

  def test_diff_simple
    expr = Expr.new('3x^2 + 2x + 1')
    expr.diff('x')
    assert_equal '6x + 2', expr.to_s
  end

  def test_diff_remove_zero_terms
    expr = Expr.new('x + 5')
    expr.diff('y')          # дифференцирование по другой переменной обнуляет все термы
    assert_equal '0', expr.to_s
  end

  def test_diff_with_mixed_vars
    expr = Expr.new('3x^2 + 4y^3 + x')
    expr.diff('x')
    assert_equal '6x + 1', expr.to_s
  end

  def test_diff_chain
    expr = Expr.new('x^3 + x^2')
    expr.diff('x').diff('x')
    assert_equal '6x + 2', expr.to_s
  end

  def test_diff_returns_self
    expr = Expr.new('x')
    assert_same expr, expr.diff('x')
  end
  def test_addition
    expr = Expr.new('x')
    expr + Term.new('2x')
    assert_equal 'x + 2x', expr.to_s
  end

  def test_subtraction
    expr = Expr.new('x')
    expr - Term.new('2x')
    assert_equal 'x - 2x', expr.to_s
  end

  def test_addition_with_constant
    expr = Expr.new('x')
    expr + Term.new('5')
    assert_equal 'x + 5', expr.to_s
  end

  def test_subtraction_with_negative
    expr = Expr.new('x')
    expr - Term.new('-3x')   # other = Term.new('-3x'), после mult(-1) станет 3x
    assert_equal 'x + 3x', expr.to_s
  end

  def test_to_s_empty
    expr = Expr.new
    assert_equal '0', expr.to_s
  end

  def test_to_s_after_diff_all_zero
    expr = Expr.new('x + y')
    expr.diff('z')
    assert_equal '0', expr.to_s
  end

  def test_to_s_single_term
    expr = Expr.new('42x')
    assert_equal '42x', expr.to_s
  end

  def test_to_s_single_negative_term
    expr = Expr.new('-3y')
    assert_equal '-3y', expr.to_s
  end
end