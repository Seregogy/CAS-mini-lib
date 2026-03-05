class Term
  private

  def validate_ctor(term)
    throw 'Invalid type' unless term.is_a?(String)
    throw 'Term name is empty' if term.empty?
    throw 'Term name contains invalid characters' if term.match?(/[^A-Za-z]/)
  end

  public

  def initialize(term)
    validate_ctor(term)
    @term_name = term

    @term_multiplier = 1
    @term_pow = 1
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

  def diff
    @term_multiplier = 0 if @term_pow.zero?
    @term_name = nil if @term_pow == 1

    if @term_multiplier > 1
      @term_multiplier *= @term_pow
      @term_pow -= 1
    end

    self
  end

  def to_s
    prefix = @term_multiplier > 1 ? @term_multiplier : nil
    suffix = @term_pow > 1 ? "^#{@term_pow}" : nil

    "#{prefix}#{@term_name}#{suffix}"
  end
end
