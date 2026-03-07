# frozen_string_literal: true

require_relative '../src/lib/term'
require_relative '../src/lib/expr'

x = Term.new('x').mult(2).pow(3)
y = Term.new('y').mult(3).pow(2)

snegovii = Expr.new(x, y, '+')

puts snegovii

snegovii.diff
snegovii.diff
puts snegovii
