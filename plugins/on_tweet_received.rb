# coding: utf-8

require "cgi"

register_callback(:tweet) do |obj|
  tweet = CGI.unescapeHTML(obj.text)
  puts "Tweet -> @#{obj.user.screen_name}: #{tweet}"
end
