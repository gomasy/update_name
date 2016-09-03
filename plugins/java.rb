on_event(:tweet) do |obj|
  if obj.text =~ /^(?!RT).*@#{screen_name}\sあなたと\s?(j|J)(a|A)(v|V)(a|A).*$/
    twitter.update(%(@#{obj.user.screen_name}\n今すぐダウンロー\nド), :in_reply_to_status_id => obj.id)
  end
end
