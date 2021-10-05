require_relative 'lib'
require_relative 'gruff'

j = {}
Dir['*'].each do |file_name|
    if file_name.include?("access.log")
        json = Template.new(file_name).get_ua
        j.merge!(json) { |k, m, n| m + n }
        #json = json.delete_if {|key, value| key[1] == "/" or key[  
    end
end
out = []
j.each do |key, value|
    u = UAHelper.new(key)
    out << u.product.gsub(")", "") if not u.product.nil? 
end
o = Template.new().count_total(out)
puts o
SaveBar.new(o, "ips_ddddd.png", title: "UA product", json: true, num: 10, show_labels: true).create_bar