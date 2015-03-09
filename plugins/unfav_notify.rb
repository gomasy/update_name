on_event(:event) do |obj|
  if obj.name == :unfavorite
    twitter.update(
      "@#{obj.source.screen_name} あんふぁぼを見たよヾ(｡>﹏<｡)ﾉﾞ",
      :in_reply_to_status_id => obj.target_object.id
    )
  end
end
