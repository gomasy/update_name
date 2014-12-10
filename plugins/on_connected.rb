# coding: utf-8

register_callback(:friends) do |obj|
  screen_name = @credentials.screen_name
  puts "System -> Start streaming of @#{screen_name}..."
end
