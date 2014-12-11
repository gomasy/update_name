# coding: utf-8

require "twitter"

class Account
  def initialize(token)
    @rest = Twitter::REST::Client.new(token)
    @stream = Twitter::Streaming::Client.new(token)
    @credentials = @rest.verify_credentials
    @callbacks = {}
  end

  def register_callback(event, &blk)
    @callbacks[event] ||= []
    @callbacks[event] << blk
  end

  def callback(event, obj)
    if @callbacks.key?(event)
      @callbacks[event].each do |c|
        c.call(obj)
      end
    end
  end

  def start
    loop do
      @stream.user do |obj|
        following = false
        case obj
        when Twitter::Tweet
          @followings.each do |id|
            if obj.user.id == id
              following = true
              break
            end
          end
          callback(:tweet, obj) if following
        when Twitter::Streaming::DeletedTweet
          @followings.each do |id|
            if obj.user_id == id
              following = true
              break
            end
          end
          callback(:delete, obj) if following
        when Twitter::Streaming::Event
          @followings.each do |id|
            if obj.source.id == id
              following = true
              break
            end
          end
          callback(:event, obj) if following
        when Twitter::Streaming::FriendList
          @followings = obj
          @followings << @credentials.id
          callback(:friends, obj)
        end
      end
    end
  rescue Exception => ex
    puts "System -> #{ex.message}"
  end
end
