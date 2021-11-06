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
  opts.on("-ip", "ip") do |v|
    options[:ip]     = true
  end
  opts.on("-path") do |v|
    options[:path]   = true
  end
  opts.on("--json=[TYPE]") do |v|
    options[:json] = true
  end
  opts.on("--status [STATUS]", "status") do |v|
    options[:status] = true
  end
  opts.on("--sort [SORT]") do |v|
    options[:sort]   = true
  end
  opts.on("-date", "date") do |v|
    options[:date]   = true
  end
  opts.on("-meth", "methods") do |v|
    options[:meth]   = true
  end
  opts.on("-ssh") do |v|
    options[:ssh]    = true
  end
  opts.on("--pt [PT]", "print table") do |v|
      options[:pt]   = v
  end
  opts.on("--s [S]", "Stats") do |v|
      options[:s]    = v
  end
  opts.on("--type [TYPE]") do |v|
    options[:type]   = v
  end
  opts.on("--sip [IP]", "type=TYPE","search ip") do |v|
      options[:sip]  =  v
  end
end.parse!
def logs_crawl(type, name)
    lc  = LogsCrawl.new(type).run
    png = FileDate.new(".png", type: name).date_file
    SaveBar.new(lc, png, title: name, json: true, num: 10, show_labels: true).create_bar
end 
if options[:date]
  logs_crawl(1, "date")
end
if options[:status]
  logs_crawl(2, "status")
end
if options[:ip]
  if options[:print]
    lc   = LogsCrawl.new(3).run
    if options[:sort]
      lc = lc.sort_by{|k,v| -v}
    end
    lc.each do |k,v|
      puts k + " - " + v.to_s
    end
  else
    logs_crawl(3, "ip")
  end
end
if options[:path]
  if options[:print]
    lc   = LogsCrawl.new(4).run
    if options[:sort]
      lc = lc.sort_by{|k,v| -v}
    end
    lc.each do |k,v|
      puts k + " - " + v.to_s
    end
  else
    logs_crawl(4, "path")
  end
end
if options[:ua]
  logs_crawl(5, "ua")
end
if options[:meth]
  logs_crawl(6, "Meth")
end
if options[:ssh]
  date   = Date.today.to_s + ".access"+ ".log"
  d      = DownloadFile.new(date).dl_file
end
if options[:pt]
  j      = LogsCrawl.new(options[:pt].to_i).run
  Print.new(j.first(10), width:100).print_table
end
if options[:s]
  stats  = Stats.new(options[:s].to_i).run
  s      = options[:s].to_i
  if options[:print].nil?
    png    = FileDate.new(".png", type: s.to_s ).date_file
    SaveBar.new(stats.first(10), png, title: "Stats", json: true, num: 10, show_labels: true).create_bar
  else
    Print.new(stats.first(10), width:100).print_table
  end
end
if options[:sip]
  lc = LogsCrawl.new(7).run(ip: options[:sip])
  p lc
end
if options[:json]
  type  = options[:type]
  tn    = Types.new(type.to_i).type_to_name
  lc    = LogsCrawl.new(type.to_i).run
  File.open("#{Date.today.to_s}-#{tn}.json", 'a') { |f| f.write(JSON.pretty_generate(lc)) }
    #JSON.generate(lc)) }
end