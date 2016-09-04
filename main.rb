#!/usr/bin/ruby

require "optparse"

require "./client.rb"

OPTS = ARGV.getopts("", "log-file:/dev/stdout", "log-level:info").freeze

Signal.trap(:TERM) do
  puts "Terminating..."
  exit
end

bot = TwitterBot::Client.new
bot.start_all
