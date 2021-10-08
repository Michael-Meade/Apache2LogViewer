require 'discordrb'
require 'open3'
require 'json'
Bot = Discordrb::Commands::CommandBot.new token: '', client_id:  , prefix: '.'
cmd = 'curl -F "file=@access.log" https://api.anonfiles.com/upload -k'
stdout, status = Open3.capture3(cmd)
j  = JSON.parse(stdout)
Bot.send_message("", "#{j["data"]["file"]["url"]["full"]}")