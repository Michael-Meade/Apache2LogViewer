require_relative 'lib'
require_relative 'gruff'
json = LogsCrawl.new(7).run
p json