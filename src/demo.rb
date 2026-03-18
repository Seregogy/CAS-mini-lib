# frozen_string_literal: true

require_relative '../src/lib/term'
require_relative '../src/lib/expr'

# частичная проверка термов
# puts Term.new("x").diff("x")
# puts Term.new("3x").diff("x")
# puts Term.new("x^2").diff("x")
# puts Term.new("-3x").diff("x")
# puts Term.new("3x^2").diff("x")
# puts Term.new("x").diff("x")
# puts Term.new("-x").diff("x")

#частичная проверка на выражения
# puts Expr.new()
# можно добавить парсер для выражения 2*x^3 + 2*y

# старая версия!!!!!!!!!!!!!
# puts Expr.new(Term.new("x"), Term.new("-3x^2")).diff("x").diff("x")
# puts Expr.new(Term.new("3x^2"), Term.new("y^4")).diff("y")
# puts Expr.new(Term.new("x^2"))
# puts Expr.new(Term.new("-3x^2"))
# puts Expr.new(Term.new("2"))

# новая версия!!!!!
# puts Expr.new("-2 + 2x - 4x^3").diff("x")

# прибери код немного и просмотри на ошибки далее нам полное покрытие надо делать