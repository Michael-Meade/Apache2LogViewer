require_relative 'lib'
require_relative 'gruff'
j = {}
Dir['*'].each do |file_name|
    if file_name.include?("access.log")
        json = Template.new(file_name).get_ip
        j.merge!(json) { |k, m, n| m + n }
        #json = json.delete_if {|key, value| key[1] == "/" or key[  
    end
SaveBar.new(j, "ips_ddddd.png", title: "IPs", json: true, num: 10, show_labels: true).create_bar
end