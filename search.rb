require_relative 'lib'
require_relative 'gruff'
=begin
j = {}
Dir['*'].each do |file_name|
    if file_name.include?("access.log")
        json = Template.new(file_name).search("117.131.199.100", 2)
        j.merge!(json) { |k, m, n| m + n }
    end
end
p j
=end

p Search.new("2021-11-11-ip.json", 4, "boo2.json").combine