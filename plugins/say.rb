# coding: utf-8

require "cgi"

register_callback(:tweet) do |obj|
  screen_name = @credentials.screen_name
  following = false
  @followings.each do |id|
    if obj.user.id == id
      following = true
    end
  end
  if following
    case CGI.unescapeHTML(obj.text)
    when /^(?!RT).*@#{screen_name}\ssay\s(.+?)$/
      @rest.update($1.sub(/@|＠/, "@\u200b"))
    end
  end
end
