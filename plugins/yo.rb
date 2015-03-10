on_event(:tweet) do |obj|
  if obj.text == "Yo"
    twitter.update("Yo")
  end
end
