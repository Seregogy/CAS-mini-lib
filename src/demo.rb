# frozen_string_literal: true

require_relative '../src/lib/symbol'

x = Term.new('x')
y = Term.new('y')

x.mult(2)
 .pow(2)
 .pow(2)
 .mult(2)

y.mult(32)

puts x
puts y
