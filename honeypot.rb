require_relative 'lib'
require_relative 'gruff'
j = {}
hp = HoneyPot.new.scan
j.merge!(hp) { |k, m, n| m + n }
p j