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
