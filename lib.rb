require 'date'
require 'terminal-table'
require 'json'
require 'net/ssh'
require 'colorize'
require 'json'
class HoneyPot
    def initialize(config_file: "honeypot_config.json", type: 4)
        @config_file = config_file
        @read        = JSON.parse(File.read(@config_file).to_s)
        @type        = type
    end
    def read_config
        @read["files"]
    end
    def scan
        config = read_config
        j      = LogsCrawl.new(@type).run
        jj     = {}
        config.each do |c|
            found     =  c if j.keys.any?(c)
            if !found.nil?
                jj[c] = j[found]
            end
        end
    return jj
    end
end
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

    def ip_path
        ips = []
        h   = {}
        # scrapes all the IPS
        get_ip.each { |key, value| ips << key }.uniq 
        # Uses the path_ip(ip) method to get all the web paths 
        # that it finds for that IP.
        ips.each_with_index do |ip|
            path  = path_ip(ip)
            path  = path.delete_if {|key, value| key.nil? or key.empty?}
            h[ip] = [path.compact]
        end
    # returns a hash with 
    # IPS as key and all the web paths that was found .
    return h
    end
    def path_ip(ip)
        # gets all the paths from a certain IP.
        status  = []
        @read.each do |i|
            if not i.split('"').nil?
                if i.split("- -")[0].strip == ip
                    status << i.split('"')[2].split(" ")[0]
                end
            end
        end
    return count_total(status)
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
    def initialize(ext, type: "")
        @ext  = ext 
        @type = type
    end
    def date
        Date.today.to_s
    end
    def date_file
        if !@type.empty?
            Date.today.to_s + "-#{@type}" + @ext 
        else
            Date.today.to_s + @ext
        end
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
class Types
    def initialize(file_name, type)
        @file_name = file_name
        @type      = type
        @t         = Template.new(@file_name)
    end
    def switch_name
        if @type == "date"
            return @t.get_date
        elsif @type == "status"
            return @t.get_status
        elsif @type == "ip"
            return @t.get_ip
        elsif @type == "path"
            return @t.get_path
        elsif @type == "ua"
            return @t.get_ua
        elsif @type == "method"
            return @t.get_method
        elsif @type == "ip-path"
            return @t.ip_path
        end

    end
    def switch(ip=nil)
        if @type == 1
            return @t.get_date
        elsif @type == 2
            return @t.get_status
        elsif @type == 3
            return @t.get_ip
        elsif @type == 4
            return @t.get_path
        elsif @type == 5
            return @t.get_ua
        elsif @type == 6
            return @t.get_method
        elsif @type == 7
            return @t.ip_path
        elsif @type == 8
            if !ip.nil?
                return @t.path_ip(ip)
            end
        end
    end
end
class LogsCrawl
    def initialize(type)
        @type      = type
    end

    def run(ip: nil)
        @j = {}
        Dir['*'].each do |file_name|
            if file_name.include?("access.log")
                if ip.nil?
                    json = Types.new(file_name, @type).switch
                    @j.merge!(json) { |k, m, n| m + n }
                else
                    json = Types.new(file_name, @type).switch(ip)
                    @j.merge!(json) { |k, m, n| m + n }
                end
            end
        end
    return @j
    end
end

=begin
json = Template.new("access.log.4").get_path
#SaveFile.new(json).write_json
json = SaveFile.new(json).write_json
#Print.new(json, width: 100).top_ten_pt
=end
#json = SaveFile.new(json).read_json
#Print.new(json, width: 100).top_ten_pt