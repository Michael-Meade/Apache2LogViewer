require_relative 'lib'
require_relative 'gruff'
require 'date'
require 'optparse'
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"
  opts.on("ip", "--ip") do |v|
    options[:ip]     = true
  end
  opts.on("path", "--path") do |v|
    options[:path]   = true
  end
  opts.on("status", "status") do |v|
    options[:status] = true
  end
  opts.on("date", "--date") do |v|
    options[:date]   = true
  end
  opts.on("meth", "--meth") do |v|
    options[:meth]   = true
  end
  opts.on("ssh", "--ssh") do |v|
    options[:ssh]    = true
  end
  opts.on("pt", "--pt=1", "print table") do |v|
      options[:pt]   = v
  end
  opts.on("s", "--s=", "Stats") do |v|
      options[:s]    = v
  end
  opts.on("-sip", "--sip=IP", "type=TYPE","search ip") do |v|
      options[:sip]  =  v[0]
      options[:type] =  v[1]
  end
end.parse!
def logs_crawl(type, name)
    lc  = LogsCrawl.new(type).run
    png = FileDate.new(".png", type: name).date_file
    SaveBar.new(lc, png, title: name, json: true, num: 10, show_labels: true).create_bar
end
if options[:date]
    logs_crawl(1, "date")
elsif options[:status]
    logs_crawl(2, "status")
elsif options[:ip]
    logs_crawl(3, "ip")
elsif options[:path]
    logs_crawl(4, "path")
elsif options[:ua]
    logs_crawl(5, "ua")
elsif options[:meth]
    logs_crawl(6, "Meth")
elsif options[:ssh]
    date = Date.today.to_s + ".access"+ ".log"
    d    = DownloadFile.new(date).dl_file
elsif options[:pt]
    j  = LogsCrawl.new(options[:pt].to_i).run
    Print.new(j.first(10), width:100).print_table
elsif options[:s]
    stats = Stats.new(options[:s].to_i).run
    Print.new(stats.first(10), width:100).print_table
end