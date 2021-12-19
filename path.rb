require_relative 'lib'
require_relative 'gruff'
lc   = LogsCrawl.new(4).run
j    = {}
lc.each do |k,v|
    if k.include?("Mozi")
        p k, v
        j[k] = v
    end
end
p j