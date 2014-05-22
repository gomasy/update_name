# coding: utf-8

require "cgi"

register_callback(:tweet) do |obj|
  screen_name = @credentials.screen_name
  case CGI.unescapeHTML(obj.text)
  when /^.*@#{screen_name}\ssay\s(.+?)$/
    tweet = $1
    @rest.update(tweet)
    puts "System -> said: #{tweet}"
  end
end
