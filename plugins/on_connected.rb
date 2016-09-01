on_event(:friends) do |obj|
  log.info %([System] Connected to userstream)

  config[:friends] = obj
  config[:friends] << user_id
end
