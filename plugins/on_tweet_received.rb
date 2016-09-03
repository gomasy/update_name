on_event(:tweet) do |obj|
  log.debug %([Tweet] @#{obj.user.screen_name}: #{obj.text})
end
