require_relative 'lib'
require_relative 'gruff'
require 'colorize'
=begin
j     = {}
array = []
Dir['*'].each  { |file_name| array << file_name if file_name.include?("access.log") }
array.sort.reverse.first(5).each do |i|
    json = Template.new(i).get_ip
    j.merge!(json) { |k, m, n| m + n }
end
type = "IP"
png  = FileDate.new(".png", type: type).date_file
puts png
SaveBar.new(j, png, title: type, json: true, num: 10, show_labels: true).create_bar

=end
arg = ARGV 

banner="
.d8888.  .d88b.  d8888b. d888888b      d8888b.  .d8b.  d888888b d88888b 
88'  YP .8P  Y8. 88  `8D `~~88~~'      88  `8D d8' `8b `~~88~~' 88'     
`8bo.   88    88 88oobY'    88         88   88 88ooo88    88    88ooooo 
  `Y8b. 88    88 88`8b      88         88   88 88~~~88    88    88~~~~~ 
db   8D `8b  d8' 88 `88.    88         88  .8D 88   88    88    88.     
`8888Y'  `Y88P'  88   YD    YP         Y8888D' YP   YP    YP    Y88888P 
"
puts banner.to_s.red

if arg[0].to_s == "-sd" && !arg[1].nil?
    if !arg[2].nil?
        if arg[2].to_s == "-dc"
            dc = arg[2] 
        end
    else
        dc = 7
    end
    j = Sort.new(type: arg[1].to_i, day_count: dc.to_i).date_sort
    p j
end

# ruby sort_date.rb -sd 4