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

Search.new("ip_auto_test.json", 2, "boo.json").combine