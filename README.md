
<div align="center">

**[INSTALLING GEMS](https://github.com/Michael-Meade/Apache2LogViewer/blob/main/README.md#Installing-the-gems-needed) • 
    [COMMAND LINE PROGRAM](https://github.com/Michael-Meade/Apache2LogViewer/blob/main/README.md#program.rb) • 
    [COMMANDS](https://github.com/Michael-Meade/Apache2LogViewer/blob/main/README.md#commands)**
    
</div>

# Apache2LogViewer
More info can be found @ <a href="https://michael-meade.github.io/Projects/program.rb-Apache2-log-viewer.html">https://michael-meade.github.io/Projects/program.rb-Apache2-log-viewer.html</a>

# Installing the gems needed
```bash
gem install terminal-table

```
```bash
gem install gruff

```
```bash
gem install colorize
```

# Read from json file print table
```ruby
require_relative 'lib'
# read ips.json
json = SaveFile.new(file_name: "ips.json").read_json
# prints out the Table showing the IPs
Print.new(json, width: 100).top_ten_pt
```
The code on the first line of the snippet above is really important. It is needed to access the SaveFile & the Print class.  The code will read the `ips.json` class and `Print` class.

<img src="https://i.imgur.com/NojABOE.png" alt="table showing top ips"  width="75%" height="75%">

# Save Json

```ruby
require_relative 'lib'
# Scrapes the ips from the apache2 log file. 
json = Template.new("access.log.4").get_ip
# save the ips into a file named ips.json
SaveFile.new(json, "ips.json").write_json
```

The code above will read the access.log.4 file and get all the ips found in the logs. Next the 
code will use the SaveFile class and the write_json method to save the ips and the number of times it was seen.
# get_date method
```ruby

require_relative 'lib'
# Scrapes the ips from the apache2 log file. 
json = Template.new("access.log").get_date
SaveBar.new(json, "test.png", title: "Date", json: true).create_bar
```


# get_status method
More information about response status can be found  <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Status">here</a>
Calling this method will parse the apache2 logs and create a JSON file that contains the number of tiems each status code was seen. 

# get_ua
User Agents are used to tell the website what type of device you are. User-agents have information about the device like the Operating system, the type of browser. The user sending the requests can change the user-agent to anything they want. A lot of scripts or programs will change their useragent to the name of the project. For example, the user agent went someone is using cURL to send requests to a site will contain Curl. This can be changed easily. User agents also allow web sites to act differently depending on the type of device, os or even the browser. 

```ruby
require_relative 'lib'
# Scrapes the ips from the apache2 log file. 
json = Template.new("access.log.4").get_ip

```
More information about user agents can be found <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/User-Agent">here</a>

# get_method
```ruby
require_relative 'lib'
# Scrapes the ips from the apache2 log file. 
json = Template.new("access.log.4").get_ip


```

# Download the access.log file remotely
```ruby
require_relative 'lib'
require 'date'
# get the apache2 logs on a remote server
date = Date.today.to_s + ".access"+ ".log"
d    = DownloadFile.new(date)
d.dl_file
```

# Using the SaveBar class
```ruby
require_relative 'lib'
require_relative 'gruff'
json = Template.new("access.log").get_path
png  = FileDate.new(".png").date_file
SaveBar.new(json, png, title: "Paths", json: true).create_bar

```
The `SaveBar` class is used to take the JSON that was scraped from the logs and it will create a bar graph with the data. 
The `SaveBar` class has a instance variable that is named json. If `json` was set as true then the class will accept JSON data instead of reading a JSON file. If the instance variable json was set to false then the class will accept JSON files. The title of the graph is Paths. The `FileDate` class can be used to get create a file with the current date in the name as its name. The FileDate class is used in the example above to create a string with the current date. This string will be name of the PNG file that contains the bar graph.

# Scraping logs & create bar graph w/o saving JSON
```ruby
require_relative 'lib'
require_relative 'gruff'
j = {}
Dir['*'].each do |file_name|
    if file_name.include?("access.log")
        json = Template.new(file_name).get_path
        j.merge!(json) { |k, m, n| m + n }
    end
end
png = FileDate.new(".png").date_file
SaveBar.new(j, png, title: "IPS", json: true).create_bar

```
# Discord.rb
```ruby
require 'discordrb'
require 'open3'
require 'json'
Bot = Discordrb::Commands::CommandBot.new token: '', client_id:  , prefix: '.'
cmd = 'curl -F "file=@access.log" https://api.anonfiles.com/upload -k'
stdout, status = Open3.capture3(cmd)
j = JSON.parse(stdout)
Bot.send_message("", "#{j["data"]["file"]["url"]["full"]}")

```

The code is meant to be ran by a cronjob every day at 6 PM. Make sure that the add your token, client id and Discord channel id. The code will upload your access.log to anonfiles.com. Then send the URL to a dicord channel of your choice. 
```bash
0 18 * * * cd /var/log/apache2; ruby Discord.rb >/dev/null 2>&1

```
The snippet above is the crontab that I used on VPS to run the script. It will run every day at 6:00 PM.


# honeypot.rb
```ruby
puts HoneyPot.new(type: 4).scan

```
The code above uses the HoneyPot class. It allows its users to create a config that contains a JSON hash of all the paths they created on their web server. For example if the user created a fake login page for Mysql that will save the inputed data. The user could add the web path to the config file. When `HoneyPot.new(type: 4).scan` is called the code will look through all the access.log files and count the number of times that honeypot web path was vistited.



|     type #    |    method     |
| ------------- | ------------- |
|       1       |   get_date    |
|       2       |   get_status  |
|       3       |   get_ip      |
|       4       |   get_path    |
|       5       |   get_ua      |
|       6       |   get_method  |
|       7       |   ip_path     |

The table above shows the different types that of scraping that can be done. In the code snippet above we used the `get_path` method to get all the web paths that were vistited.


|  method name  |    method     |
| ------------- | ------------- |
|  "date"       |   get_date    |
|  "status"     |   get_status  |
|  "ip"         |   get_ip      |
|  "path"       |   get_path    |
|  "ua"         |   get_ua      |
|  "method"     |   get_method  |
|  "ip_path"    |   ip_path     | 

```ruby
Type.new("access.log", "date").switch_name

```
The snippet above shows the Type class in action. Instead of using a number for thet type, the `switch_name` method uses names to get the name of the method to run. The code snippet above will extract dates from the logs. 

# Log Crawling
```ruby
require_relative 'lib'
puts LogsCrawl.new(4).run

```
Instead of having to reuse the same code everytime  ( auto_scrape.rb) when the user wants to loop through all thefiles in the directory looking for access.logs, the `LogsCrawl` class can be called.  Similiar to the hoenypot code, the class uses the same types listed in the table above. The code will return a HASH with the data from the logs. 


# program.rb

Get stats of IPs
```ruby
ruby program.rb --s 3
```
Get IP - will create a bar graph
```ruby 
ruby program.rb -ip
```
Get Paths - will create a bar graph
```ruby
ruby program.rb -path
```
Get Status - Will crate bar graph
```ruby
ruby program.rb -status
```
Print out stats table
```ruby
ruby program.rb --s 3 --print
```
List Types
```ruby
    ruby program.rb -list
```
The 3 is the type, IP.
More examples can be found <a href="https://michael-meade.github.io/Projects/apache2-log-reader.html">here,</a> <a href="https://michael-meade.github.io/Projects/program.rb-Apache2-log-viewer.html">here</a>


# Samples
```ruby
require_relative 'lib'
require_relative 'gruff'
require 'json'


p Sample.new(3).run 
```
# Percent
```ruby
require_relative 'lib'
require_relative 'gruff'
stats  = Stats.new(3)
ips    = stats.run
j      = ips.sort_by {|k, v| v}.reverse.first(10)

Print.new(j, "IPs in %", "ip", "%").print_table
```
The code will use the Stats class to get the data. Sort the data and grab the first 10 elements. The print class will take the top ten IP array and print out a table displaying the results.

# Sort Date
```ruby
require_relative 'lib'
require_relative 'gruff'
j     = {}
array = []
Dir['*'].each  { |file_name| array << file_name if file_name.include?("access.log") }
array.sort.reverse.first(3).each do |i|
    json = Template.new(i).get_ip
    j.merge!(json) { |k, m, n| m + n }
end
type = "IP"
png  = FileDate.new(".png", type: type).date_file
SaveBar.new(j, png, title: type, json: true, num: 10, show_labels: true).create_bar
```
The code above will extract the IPs of the three latest logs and display the information in a bar graph. The code will first create an array with all the files that include the string "access.log". Next the code will sort the elements in order and grab the first three elements. The code will then loop through the array using the elements to input the log file names into the Template class so that the top IPs can be extracted from the log files and made into a bar graph. 

# Date2
```ruby
require_relative 'lib'
require_relative 'gruff'
j = {}
Dir['*'].each do |file_name|
    if file_name.include?("access.log")
        json = Template.new(file_name).get_date2
        j.merge!(json) { |k, m, n| m + n }
    end
end

SaveBar.new(j, "date2.png", title: "Dates", json: true, num: 10, show_labels: true).create_bar
```
The `date2` method is a improvement of date. The code now only gets the Month, day and year instead of the whole time stamp.