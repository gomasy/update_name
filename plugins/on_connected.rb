on_event(:friends) do |obj|
  log.info %([System] Connecting to userstream...)

  config[:friends] = obj
  config[:friends] << user_id
end
