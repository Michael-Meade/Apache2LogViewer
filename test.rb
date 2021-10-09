require_relative 'lib'
#puts LogsCrawl.new(4).run

p Template.instance_methods(false)  
require_relative 'gruff'
j = {}
Dir['*'].each do |file_name|
    if file_name.include?("access.log")
        json = Template.new(file_name).get_status
        p Template.name
        j.merge!(json) { |k, m, n| m + n }
        #json = json.delete_if {|key, value| key[1] == "/" or key[  
    end
png = FileDate.new(".png", type: "ip").date_file
SaveBar.new(j, png, title: "ip", json: true, num: 10, show_labels: true).create_bar
end