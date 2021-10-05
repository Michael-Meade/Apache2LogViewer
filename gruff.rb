require 'gruff'
require_relative 'lib'
require 'json'
class SaveBar
  def initialize(file_name, out, title: nil, json: false, num: 10, show_labels: false)
    @title       = title
    @out         = out
    @g           = Gruff::Bar.new(1000)
    @file_name   = file_name
    @json        = json
    @num         = num
    @show_labels = show_labels
    if !json
      @j        = JSON.parse(File.read(@file_name)).sort_by{|k,v| -v}.first(@num).to_h
    else 
      @j        = @file_name.sort_by{|k,v| -v}.first(@num)
    end
  end
  def color2
    ii = []
    t  = @num.times.map { "%06x" % (rand * 0xffffff) }.to_a
    t.each {|i| ii << "##{i}" }
    return ii
  end
  def color
    ["#0000FF", "#f50f81", "#e36c9f", "#de92d6", "#92f568", "#FF0000", "#e2dc54", "#947cac", "#657f3b", "#3ba1fb", "#14521a"]
  end
  def create_bar
    @g.title  = @title
    @g.colors = color2
    @g.show_labels_for_bar_values = @show_labels
    #@g.group_spacing = 15
    @j.each do |data|
      @g.data(data[0], data[1])
    end
    @g.write(@out)
  end
end

#json = Template.new("access.log").get_ip
#SaveBar.new(json, "ips_ddddd.png", title: "IPS", json: true).create_bar