require "cgi"

on_event(:tweet) do |obj|
  log.debug %([Tweet] @#{obj.user.screen_name}: #{CGI.unescapeHTML(obj.text)})
end
