# coding: utf-8

register_callback(:event) do |obj|
  following = false
  @followings.each do |id|
    if obj.source.id == id
      following = true
      break
    end
  end
  if following
    case obj.name
    when :unfavorite
      @rest.update(
        "@#{obj.source.screen_name} あんふぁぼを見たよヾ(｡>﹏<｡)ﾉﾞ",
        :in_reply_to_status_id => obj.target_object.id
      )
    end
  end
end
