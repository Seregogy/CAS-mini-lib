class Expression < Term
  def initialize(left, right, operator)
    super('expr')

    @left_term = left
    @right_term = right
    @operator = operator
  end

  def diff
    @left_term.diff
    @right_term.diff
  end

  def +(other)
    Expression.new(self, other, '+')
  end

  def -(l_expr, r_expr)
    Expression.new(l_expr, r_expr, '-')
  end


  def to_s
    "#{@left_term} #{@operator} #{@right_term}"
  end
end