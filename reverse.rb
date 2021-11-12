require_relative 'lib'
require_relative 'gruff'
require 'json'


s = Sample.new(3).run
SaveBar.new(s, "sample.png", title: "t", json: true, num: 10, show_labels: true).create_bar