require_relative 'lib'
require_relative 'gruff'
# type 7 is ip & paths (ip_path)
json = LogsCrawl.new(7).run
p json