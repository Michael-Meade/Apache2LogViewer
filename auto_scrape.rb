require_relative 'lib'
require_relative 'gruff'
Dir['*'].each do |file_name|
    if file_name.include?("access.log")
        json = Template.new(file_name).get_path
        SaveFile.new(json, file_name:"ip_auto_test.json").write_json
    end
end
j  = SaveFile.new(file_name: "ip_auto_test.json").read_json

# prints out the Table showing the IPs
#Print.new(j, width: 40).top_ten_pt

# create bar graph with the data
SaveBar.new("ip_auto_test.json", "ips.png", title: "IPS").create_bar
