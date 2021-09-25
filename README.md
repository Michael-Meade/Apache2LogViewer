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

<img src="https://i.imgur.com/NojABOE.png" alt="table showing top ips"  width="75%" height="75%">

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

### get_status method
More information about response status can be found  <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Status">here</a>
Calling this method will parse the apache2 logs and create a JSON file that contains the number of tiems each status code was seen. 

### get_ua
User Agents are used to tell the website what type of device you are. User-agents have information about the device like the Operating system, the type of browser. The user sending the requests can change the user-agent to anything they want. A lot of scripts or programs will change their useragent to the name of the project. For example, the user agent went someone is using cURL to send requests to a site will contain Curl. This can be changed easily. User agents also allow web sites to act differently depending on the type of device, os or even the browser. 

```ruby
require_relative 'lib'
# Scrapes the ips from the apache2 log file. 
json = Template.new("access.log.4").get_ip

```
More information about user agents can be found <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/User-Agent">here</a>



More examples can be found <a href="https://michael-meade.github.io/Projects/apache2-log-reader.html">here.</a>