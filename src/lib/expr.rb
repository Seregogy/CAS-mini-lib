class Expr < Term

  # def initialize(left, right, operator)
  #   super('expr')
  #
  #   @left_term = left
  #   @right_term = right
  #   @operator = operator
  # end

  public

  def initialize(*args)
    # если хочешь заморочся с regex для парсинга строки 4x^2 + y - 10
    @terms = args.to_ary
  end

  def diff(symb)
    temp = Array.new
    for term in @terms
      term.diff(symb)
      if term.to_s.eql?("0")
        temp.push(term)
      end
    end
    for term in temp
      @terms.delete(term)
    end
    self
  end

  def +(other)
    @terms.push(other)
    self
  end

  def -(other)
    other.mult(-1)
    @terms.push(other)
    self
  end

  def to_s # хз добавь поле isnegative для упрощения читаемости
    return "0" if @terms.length == 0
    s = ""
    for term in @terms
      if term.to_s[0].eql?("-")
        s += "- #{term.to_s[1, term.to_s.length]} "
      else
        s += "+ #{term.to_s} "
      end
    end
    if s[0].eql?("-")
      return "-"+s[2,s.length]
    end
    s[2, s.length]
  end
end