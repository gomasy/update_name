# coding: utf-8

require "twitter"

class Account
  def initialize(token)
    @rest = Twitter::REST::Client.new(token)
    @stream = Twitter::Streaming::Client.new(token)
    @credentials = @rest.verify_credentials
    @callbacks = {}
  end

  def start
    loop do
      @stream.user do |obj|
        following = false
        case obj
        when Twitter::Tweet
          callback(:tweet, obj) if is_allowed?(obj.user.id)
        when Twitter::Streaming::DeletedTweet
          callback(:delete, obj) if is_allowed?(obj.user_id)
        when Twitter::Streaming::Event
          callback(:event, obj) if is_allowed?(obj.source.id)
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

  private
  def register_callback(event, &blk)
    @callbacks[event] ||= []
    @callbacks[event] << blk
  end

  def callback(event, obj)
    @callbacks[event].each{|c|c.call(obj)} if @callbacks.key?(event)
  end

  def is_allowed?(user_id)
    following = false
    @followings.each do |id|
      if user_id == id
        following = true
        break
      end
    end
    return following
  end

  def twitter
    return @rest
  end

  def screen_name
    return @credentials.screen_name
  end

  def user_id
    return @credentials.user_id
  end
end
