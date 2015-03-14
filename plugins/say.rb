require "cgi"

on_event(:tweet) do |obj|
  ptn = /^(?!RT).*@#{screen_name}\ssay\s((.|\n)+?)$/
  if CGI.unescapeHTML(obj.text) =~ ptn
    twitter.update($1.sub(/@/, "@\u200b"))
  end
end
