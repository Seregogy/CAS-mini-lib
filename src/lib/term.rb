class Term
  public

  def initialize(term)
    raise 'Term name is empty' if term.empty?

    # Регулярка для терма с переменной: знак-число-основание^степень
    var_regex = /^([+-]?)([0-9]*)([a-zA-Z])(?:\^(-?\d+))?$/
    # Регулярка для константы: [знак][число]
    const_regex = /^([+-]?)([0-9]+)$/

    if (m = term.match(var_regex))
      sign      = m[1]
      coeff_str = m[2]
      @term_name = m[3]
      pow_str   = m[4]
      @term_pow = pow_str ? pow_str.to_i : 1
      coeff = coeff_str.empty? ? 1 : coeff_str.to_i
      @term_multiplier = sign == '-' ? -coeff : coeff
    elsif (m = term.match(const_regex))
      sign = m[1]
      num_str = m[2]
      @term_multiplier = (sign == '-' ? -1 : 1) * num_str.to_i
      @term_pow = 0
      @term_name = '_'                      # условное имя для константы
    else
      raise "Invalid term format: #{term}"
    end
  end

  # Возведение терма в целую степень (меняет и коэффициент, и показатель)
  def pow(value)
    raise 'Invalid value type' unless value.is_a?(Integer)
    @term_pow *= value
    @term_multiplier **= value
    self
  end

  # Умножение коэффициента на целое число
  def mult(value)
    raise 'Invalid value type' unless value.is_a?(Integer)
    @term_multiplier *= value
    self
  end

  # Дифференцирование по переменной symb
  def diff(symb)
    raise 'incorrect symbol for difference' unless symb.is_a?(String)

    unless @term_name.eql?(symb)
      @term_multiplier = 0
      return self
    end
    @term_multiplier *= @term_pow
    @term_pow -= 1
    self
  end

  # Строковое представление терма
  def to_s
    return '0' if @term_multiplier.zero?
    return @term_multiplier.to_s if @term_pow.zero?

    # Формируем коэффициент (со знаком, если нужно)
    coeff_part = if @term_multiplier == 1
                   ''
                 elsif @term_multiplier == -1
                   '-'
                 else
                   @term_multiplier.to_s
                 end

    return "#{coeff_part}#{@term_name}" if @term_pow == 1

    "#{coeff_part}#{@term_name}^#{@term_pow}"
  end
end