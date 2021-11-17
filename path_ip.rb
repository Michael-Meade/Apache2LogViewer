require_relative 'lib'
require_relative 'gruff'
j = {}
Dir['*'].each do |file_name|
    if file_name.include?("access.log")
        json = Template.new(file_name).get_ip
        j.merge!(json) { |k, m, n| m + n }
        #json = json.delete_if {|key, value| key[1] == "/" or key[  
    end
end
#p j
array = []
Dir['*'].each  { |file_name| array << file_name if file_name.include?("access.log") }
p array.sort.reverse
type = "IP"
png = FileDate.new(".png", type: type).date_file
SaveBar.new(j, png, title: type, json: true, num: 10, show_labels: true).create_bar