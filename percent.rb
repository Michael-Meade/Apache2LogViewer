require_relative 'lib'
require_relative 'gruff'
stats  = Stats.new(3)
ips    = stats.run
j      = ips.sort_by {|k, v| v}.reverse.first(10)

Print.new(j, "IPs in %", "ip", "%").print_table