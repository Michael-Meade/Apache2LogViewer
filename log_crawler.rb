require_relative 'lib'
require_relative 'gruff'
require 'json'
def ips
    data   = LogsCrawl.new(3).run
    type   = "IPs"
    fd     = FileDate.new(".png", type: type)
    SaveBar.new(data.sort_by{|k,v| -v}.first(10), fd.date_file, title: type + " " + fd.date, json: true, num: 10, show_labels: true).create_bar
end
def paths
    data   = LogsCrawl.new(4).run
    type   = "Paths"
    fd     = FileDate.new(".png", type: type)
    SaveBar.new(data.sort_by{|k,v| -v}.first(10), fd.date_file, title: type + " " + fd.date, json: true, num: 10, show_labels: true).create_bar
end