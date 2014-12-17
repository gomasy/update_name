# coding: utf-8

require "cgi"

on_event(:tweet) do |obj|
  puts "Tweet -> @#{obj.user.screen_name}: #{CGI.unescapeHTML(obj.text)}"
end
