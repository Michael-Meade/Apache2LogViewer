#require "anomaly"
require 'pp'
require_relative 'lib'
require_relative 'gruff'
#require 'outliertree'
require 'json'
=begin
examples = 10_000.times.map { [rand, rand(10), rand(100), 0] } +
       100.times.map { [rand + 1, rand(10) + 2, rand(100) + 20, 1] }
ad = Anomaly::Detector.new(examples)
puts ad.anomaly?([10, 7, 9])
puts ad.probability([0,7,9])
=end

r = File.read("2021-11-12-ip.json")
j = JSON.parse(r)
out = {}
j.each do |k,v|
       t = {
              "#{k}" => v
       }
       out.merge!(t)
end
jj = {}
j.each do |k,v|
       j = LogsCrawl.new(4).run(ip: k)
       jj.merge!(j)
end
p jj.sort_by{|k,v| -v}
