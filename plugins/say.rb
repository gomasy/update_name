# coding: utf-8

require "cgi"

register_callback(:tweet) do |obj|
  screen_name = @credentials.screen_name
  case CGI.unescapeHTML(obj.text)
  when /^(?!RT).*@#{screen_name}\ssay\s(.+?)$/
    @rest.update($1.sub(/@|＠/, "@​"))
  end
end
