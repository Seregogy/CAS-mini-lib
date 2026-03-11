class Term
  private

  def validate_ctor(term)
    throw 'Invalid type' unless term.is_a?(String)
    throw 'Term name is empty' if term.empty?
    throw 'Term name contains invalid characters' if term.match?(/^[+-]?0/)
    throw 'Term name invalid!' unless /^(([+-]?[1-9]*)([a-zA-Z]{1})(\^(\-?[1-9]+))?)|[1-9]+$/.match?(term)
  end

  protected

  def multiplier_status
    return "" if @term_multiplier>=0 && @term_multiplier<=1
    return "-" if @term_multiplier == -1
    @term_multiplier
  end

  public

  def initialize(term)
    validate_ctor(term)

    r = /^(([+-]?[1-9]*)([a-zA-Z]{1})(\^(\-?[1-9]+))?)|([+-]?[1-9]+)$/

    res = r.match(term)
    unless res[6].nil?
      @term_multiplier = res[6].to_i
      @term_pow = 0
      @term_name = "_"
      return
    end

    @term_name = res[3]
    @term_pow = res[5].nil? ? 1 : res[5].to_i
    case res[2]
    when ""
      @term_multiplier = 1
    when "+"
      @term_multiplier = 1
    when "-"
      @term_multiplier = -1
    else
      @term_multiplier = res[1].to_i
    end
  end

  def pow(value)
    throw 'Invalid value type' unless value.is_a?(Integer)
    @term_pow *= value
    @term_multiplier **= value

    self
  end

  def mult(value)
    throw 'Invalid value type' unless value.is_a?(Integer)
    @term_multiplier *= value

    self
  end

  def diff(symb)
    raise "incorrect symbol for difference" unless symb.is_a?(String)

    #@term_multiplier = 0 if @term_pow.zero? # это тихий ужас / сам знаю / ну так переделай / ок
    #@term_name = nil if @term_pow == 1
    # unless symb.eql?(@term_name)
    #   @term_multiplier = 0
    #   return
    # end
    # if @term_pow.zero?
    #   unless @term_name.nil?
    #     @term_multiplier *= @term_pow
    #     @
    #   end
    # end
    # if @term_pow > 1
    #   @term_multiplier *= @term_pow
    #   @term_pow -= 1
    #
    # elsif @term_pow.negative?
    #   @term_multiplier *= @term_pow
    #   @term_pow -= 1
    # end

    unless @term_name.eql?(symb)
      @term_multiplier = 0
      return self
    end
    @term_multiplier *= @term_pow
    @term_pow -= 1
    self
  end

  def to_s # перепиши красиво чтобы было X) / ок написал / это че у вас тут за записки шизофреника
    # if @term_name.nil?
    #   return "0" if @term_multiplier.zero?
    #   if @term_pow != 0
    #     s = "#{@term_multiplier}"
    #   end
    #   if @term_pow != 1 && !@term_pow.nil?
    #     s += "^#{@term_pow}"
    #   end
    # else
    #   return "0" if !@term_multiplier.nil? && @term_multiplier.zero?
    #   if @term_multiplier != 1
    #     s = (@term_multiplier.eql?(-1) ? "-" : "#{@term_multiplier}")
    #   end
    #   s += (@term_pow.eql?(0) ? "" : (@term_pow.eql?(1) ? @term_name : "#{@term_name}^#{@term_pow}"))
    # end
    return "0" if @term_multiplier.zero?
    return "#{@term_multiplier}" if @term_pow.eql?(0)
    return "#{multiplier_status}#{@term_name}" if @term_pow.eql?(1)
    "#{multiplier_status}#{@term_name}^#{@term_pow}"
  end

end