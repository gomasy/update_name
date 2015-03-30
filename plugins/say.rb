require "cgi"

on_event(:tweet) do |obj|
  ptn = /^(?!RT).*@#{screen_name}\ssay\s((.|\n)+?)$/
  twitter.update($1.sub(/@/, "@\u200b")) if CGI.unescapeHTML(obj.text) =~ ptn
end
