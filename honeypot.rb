require_relative 'lib'
=begin
config = HoneyPot.new.read_config
j      = LogsCrawl.new(4).run
jj     = {}
config.each do |c|
	found =  c if j.keys.any?(c)
	if !found.nil?
		jj[c] = j[found]
	end
end
puts jj
=end
puts HoneyPot.new(type: 4).scan