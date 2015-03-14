on_event(:event) do |obj|
  case obj.name
  when :follow
    p config
    if obj.source.id != user_id && config["auto_fb"]
      twitter.follow(obj.source.id)
      config["followings"] << obj.source.id
    end
  when :unfollow
    config["followings"].delete(obj.target.id)
  end
end
