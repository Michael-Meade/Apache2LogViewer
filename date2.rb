require_relative 'lib'
require_relative 'gruff'
j = {}
Dir['*'].each do |file_name|
    if file_name.include?("access.log")
        json = Template.new(file_name).get_date2
        j.merge!(json) { |k, m, n| m + n }
    end
end

SaveBar.new(j, "date2.png", title: "Dates", json: true, num: 10, show_labels: true).create_bar
