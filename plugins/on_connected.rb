# coding: utf-8

register_callback(:friends) do |obj|
  @credentials = @rest.verify_credentials
  @followings = obj
  @followings << @credentials.id
  screen_name = @credentials.screen_name
  puts "System -> Start streaming of @#{screen_name}..."
end
