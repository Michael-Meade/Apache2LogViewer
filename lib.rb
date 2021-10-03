require 'date'
require 'terminal-table'
require 'json'
require 'net/ssh'
require 'json'
class SSH
    def initialize
        c      = Config.new
        @ssh   = Net::SSH.start(c.ip, c.uname, :password => c.pass, :port => c.port)
    end
    def login(cmd)
        return @ssh.exec!(cmd)
    end
end
class DownloadFile < SSH
    def initialize(file_name, cmd = "cat /var/log/apache2/access.log")
        @file_name = file_name
        @cmd       = cmd
    end
    def dl_file
        txt   = SSH.new.login(@cmd)
        File.open(@file_name, 'w') { |f| f.write(txt) }
    end
end
class Config
    def initialize
        if File.exist?("config.json")
            @json = JSON.parse(File.read("config.json").to_s)
        end
        def ip
            @json["ip"]
        end
        def uname
            @json["uname"]
        end
        def pass
            @json["pass"]
        end
        def port
            @json["port"]
        end
    end
end
class Template
    def initialize(file)
        @file = file
        @read = File.readlines(@file)
    end
    def count_total(array)
        h = {}
        array.each do |ii|
            if h.has_key?(ii)
                h[ii] +=  1
            else 
                h[ii] = 1
            end
        end
    return h
    end
    def get_date
        # todo: split up the dates & times
        date = []
        @read.each do |i|
            if not i.split("[").nil?
                date << i.split("[")[1].split("]")[0]
            end
        end
    return count_total(date)
    end
    def get_status
        status  = []
        @read.each do |i|
            if not i.split('"').nil?
                status << i.split('"')[2].split(" ")[0]
            end
        end
    return count_total(status)
    end
    def get_ip
        ips = []
        @read.each do |i|
            if not i.split(" - - ").nil?
                ips << i.split("- -")[0].strip
            end
        end
    return count_total(ips)
    end
    def get_path
        urls = []
        @read.each do |i| 
            if not i.split('"')[1].split(" ")[1].nil?
                urls << i.split('"')[1].split(" ")[1]
            end
        end
    return count_total(urls)
    end
    def get_ua
        ua = []
        @read.each do |i|
            if not i.split('"')[5].nil?
                if not i.split('"')[5] == "-"
                    ua << i.split('"')[5]
                end
            end
        end
    return count_total(ua)
    end
    def get_method
        meth = []
        @read.each do |i|
            if not i.split('"')[1].nil?
                meth << i.split('"')[1].split(" ")[0]
            end
        end
    return count_total(meth)
    end
end
class SaveFile
    def initialize(json = nil, file_name: "out.json")
        @json      = json
        @file_name = file_name
        #File.open(@file_name, 'w') { |f| f.write("{}") } if !File.exists?(@file_name)
    end
    def check_exists
        return File.exist?(@file_name)
    end
    def write_json
        if !check_exists
            File.open(@file_name, 'a') { |f| f.write(JSON.generate(@json)) }
        else
            read = File.read(@file_name)
            j    = JSON.parse(read)
            j    = @json.merge!(j) { |k, m, n| m + n }
            File.open(@file_name, 'w') {|f| f.write(j.to_json) }
        end
    end
    def read_json
        if check_exists
            r = File.read(@file_name)
            j = JSON.parse(r)
        end
    end
end
class FileDate
    def initialize(ext)
        @ext = ext 
    end
    def date_file
        Date.today.to_s + @ext
    end
end
class Print
    def initialize(json, title = nil, h1 = nil, h2 = nil, width: 40)
        @json    = json
        @title   = title
        @h1      = h1
        @h2      = h2
        @width   = width
    end
    def top_ten_pt
        out = []
        @json.sort_by{|k,v| -v}.first(10).each do |k, v|
            out << [k, v]
        end
        table = Terminal::Table.new
        if !@title.nil?
            table.title = @title
        else
            table.title = "IP attempts"
        end
        if !@h1.nil? && !@h2.nil? 
            table.headings = [@h1, @h2]
        else
            table.headings = ['IP', 'attempts']
        end
        table.rows = out
        table.style = {:width => @width, :border => :unicode_round, :alignment => :center }
        puts table
    end
    def print_table
        out = []
        @json.sort_by{|k,v| -v}.each do |k, v|
            out << [k, v]
        end
        table = Terminal::Table.new
        if !@title.nil?
            table.title = @title
        else
            table.title = "IP attempts"
        end
        if !@h1.nil? && !@h2.nil? 
            table.headings = [@h1, @h2]
        else
            table.headings = ['IP', 'attempts']
        end
        table.rows  = out
        table.style = {:width => @width, :border => :unicode_round, :alignment => :center }
        puts table
    end
end
=begin
json = Template.new("access.log.4").get_path
#SaveFile.new(json).write_json
json = SaveFile.new(json).write_json
#APrint.new(json, width: 100).top_ten_pt
=end
#json = SaveFile.new(json).read_json
#Print.new(json, width: 100).top_ten_pt