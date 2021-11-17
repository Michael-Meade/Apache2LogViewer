require_relative 'lib'
require_relative 'gruff'
j = {}

array = []
Dir['*'].each  { |file_name| array << file_name if file_name.include?("access.log") }
array.sort.reverse.first(3).each do |i|
    json = Template.new(i).get_ip
    j.merge!(json) { |k, m, n| m + n }
end

type = "IP"
png  = FileDate.new(".png", type: type).date_file
SaveBar.new(j, png, title: type, json: true, num: 10, show_labels: true).create_bar