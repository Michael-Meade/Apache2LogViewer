require_relative 'lib'
require_relative 'gruff'
ips  = []
out  = []
j    = {}
# type 7 is ip & paths (ip_path)
json2 = LogsCrawl.new(3).run
o     = json2.sort_by{|k,v| -v}
o.each {|ip| ips  <<  ip[0] }
ips.each do |ii|
 json  = LogsCrawl.new(8).run(ip: ii)
 j[ii] = json
 j.merge!(json) { |k, m, n| m + n }
end
ips.each do |ip|
    if !j[ip]["200"].nil?
        out << [ ip, j[ip]["200"], json2[ip]]
    end
end
p out