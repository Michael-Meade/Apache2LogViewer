# Apache2LogViewer
### Read from json file print table
```ruby
require_relative 'lib'
# read ips.json
json = SaveFile.new(file_name: "ips.json").read_json
# prints out the Table showing the IPs
Print.new(json, width: 100).top_ten_pt
```
The code on the first line of the snippet above is really important. It is needed to access the SaveFile & the Print class.  The code will read the `ips.json` class and `Print` class.


### Save Json

```ruby
require_relative 'lib'
# Scrapes the ips from the apache2 log file. 
json = Template.new("access.log.4").get_ip
# save the ips into a file named ips.json
SaveFile.new(json, "ips.json").write_json
```

The code above will read the access.log.4 file and get all the ips found in the logs. Next the 
code will use the SaveFile class and the write_json method to save the ips and the number of times it was seen.

### installing the gems needed
```bash
gem install terminal-table

```