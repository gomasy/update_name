def follow(id, sn)
  if id != @user.id
    @rest.follow(id)
    @config[:friends] << id

    log.info %([System] Followed to @#{sn})
  end
end

on_event(:event) do |obj|
  if obj.name == :follow
    follow(obj.source.id, obj.source.screen_name)
  end
end
