on_event(:tweet) do |obj|
  twitter.update("Yo") if obj.text == "Yo"
end
