# coding: utf-8

require "twitter"

class Account
  def initialize(token)
    @rest = Twitter::REST::Client.new(token)
    @stream = Twitter::Streaming::Client.new(token)
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
    @stream.user do |obj|
      case obj
      when Twitter::Tweet
        callback(:tweet, obj)
      when Twitter::Streaming::Event
        callback(:event, obj)
      when Twitter::Streaming::FriendList
        callback(:friends, obj)
      when Twitter::Streaming::DeletedTweet
        callback(:delete, obj)
      end
    end
  end
end
