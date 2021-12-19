require_relative 'lib'
require_relative 'gruff'
require 'json'
lc   = LogsCrawl.new(4).run
j    = {}
lc.each do |k,v|
    if k.include?("Mozi")
        j[k] = v
    end
end

SaveFile.new(j, file_name: 'mozi.json').write_json
    #txt = j.merge!(o)