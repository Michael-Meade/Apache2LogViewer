require_relative 'lib'
require_relative 'gruff'
require 'date'
require 'optparse'
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"
  opts.on("--print [PRINT]") do |v|
    options[:print]     = true
  end
  opts.on("-ip") do |v|
    #p v
    options[:ip]     = true
  end
  opts.on("-path") do |v|
    options[:path]   = true
  end
  opts.on("-status") do |v|
    options[:status] = true
  end
  opts.on("--sort [SORT]") do |v|
    options[:sort] = true
  end
  opts.on("date") do |v|
    options[:date]   = true
  end
  opts.on("meth") do |v|
    options[:meth]   = true
  end
  opts.on("ssh") do |v|
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
  if options[:print]
    lc = LogsCrawl.new(3).run
    if options[:sort]
      lc = lc.sort_by{|k,v| -v}
    end
    lc.each do |k,v|
      puts k + " - " + v.to_s
    end
  else
    logs_crawl(3, "ip")
  end
elsif options[:path]
  if options[:print]
    lc = LogsCrawl.new(4).run
    if options[:sort]
      lc = lc.sort_by{|k,v| -v}
    end
    lc.each do |k,v|
      puts k + " - " + v.to_s
    end
  else
    logs_crawl(4, "path")
  end
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