# frozen_string_literal: true

require_relative '../src/lib/symbol'

a = Term.new('x')

a.mult(2)
 .pow(2)
 .pow(2)
 .mult(2)

puts a.term_pow
puts a.term_multiplier
