require_relative 'lib'
require 'date'
# get the apache2 logs on a remote server
date = Date.today.to_s + "access"+ ".log"
d    = DownloadFile.new(date)
d.dl_file