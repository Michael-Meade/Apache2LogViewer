require_relative 'lib'
# Scrapes the ips from the apache2 log file. 
json = Template.new("access.log").get_ip
# save the ips into a file named ips.json
SaveFile.new(json, file_name: "ip.json").write_json

