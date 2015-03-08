require "cgi"

on_event(:tweet) do |obj|
  case CGI.unescapeHTML(obj.text)
  when /^(?!RT).*@#{screen_name}\ssay\s((.|\n)+?)$/
    twitter.update($1.sub(/@|＠/, "@\u200b"))
  end
end
