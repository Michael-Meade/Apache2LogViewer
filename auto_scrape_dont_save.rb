require_relative 'lib'
require_relative 'gruff'
j = {}
Dir['*'].each do |file_name|
    if file_name.include?("access.log")
        json = Template.new(file_name).get_ip
        j    = json.merge!(j)
    end
end
png = FileDate.new(".png").date_file
SaveBar.new(j, png, title: "IPS", json: true).create_bar