require_relative 'lib'
# read ips.json
json = SaveFile.new(file_name: "ip_auto_test.json").read_json
# prints out the Table showing the IPs
Print.new(json, width: 40).top_ten_pt