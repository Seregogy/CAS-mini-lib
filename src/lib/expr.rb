require_relative 'term'

# Класс для представления выражения как суммы термов
class Expr
  public

  def initialize(*args)
    if args.size == 1
      if args[0].is_a?(String)
        @terms = parse_string(args[0])
      elsif args[0].is_a?(Array)
        @terms = args[0]
      else
        @terms = args
      end
    else
      @terms = args
    end
  end

  # Дифференцирование выражения по переменной symb
  def diff(symb)
    @terms.each { |t| t.diff(symb) }
    @terms.reject! { |t| t.to_s == '0' }
    self
  end

  # Добавление терма (мутирует текущее выражение)
  def +(other)
    if other.is_a?(String)
      term = parse_string(other)
    end
    @terms << term[0]
    self
  end

  # Вычитание терма (мутирует текущее выражение)
  def -(other)
    if other.is_a?(String)
      term = parse_string(other)
    end
    other = other.gsub(/\s+/, '')
    unless other.start_with?("-")
      term[0] = term[0].mult(-1)
    end
      @terms << term[0]
    self
  end

  # Строковое представление выражения
  def to_s
    return '0' if @terms.empty?

    result = ""
    @terms.each_with_index do |t, i|
      s = t.to_s
      if s.start_with?('-')
        result += (i.zero? ? s : " - #{s[1..-1]}")
      else
        result += (i.zero? ? s : " + #{s}")
      end
    end
    result
  end

  private

  # Разбор строки вида "x + 2y - 3x^2" в массив термов
  def parse_string(str)
    s = str.gsub(/\s+/, '')          # удаляем пробелы
    return [] if s.empty?

    s = '+' + s unless s.start_with?('+', '-')
    terms = []
    s.scan(/[+-]?(?:\d*[a-zA-Z](?:\^[+-]?\d+)?|\d+)/) do |token|
      next if token.empty?
      terms << Term.new(token)
    end
    terms
  end
end