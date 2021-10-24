require_relative 'lib'
require_relative 'gruff'
require 'json'
data   = LogsCrawl.new(3).run
type   = "IPs"
fd     = FileDate.new(".png", type: type)
SaveBar.new(data.sort_by{|k,v| -v}.first(10), fd.date_file, title: type + " " + fd.date, json: true, num: 10, show_labels: true).create_bar