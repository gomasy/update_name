# coding: utf-8

register_callback(:friends) do |obj|
  @credentials = @rest.verify_credentials
  @followings = obj
  # 自分にも反応するように
  @followings << @credentials.id
end
