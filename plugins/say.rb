# coding: utf-8

require "cgi"

on_event(:tweet) do |obj|
  case CGI.unescapeHTML(obj.text)
  when /^(?!RT).*@#{screen_name}\ssay\s(.+?)$/
    twitter.update($1.sub(/@|＠/, "@\u200b"))
  end
end
