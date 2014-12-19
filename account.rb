# coding: utf-8

require "twitter"

class Account
  attr_reader :rest, :user

  def initialize(token)
    @rest = Twitter::REST::Client.new(token)
    @stream = Twitter::Streaming::Client.new(token)
    @user = @rest.verify_credentials
    @callbacks = {}
  end

  def start
    loop do
      @stream.user do |obj|
        begin
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
            @followings << @user.id
            callback(:friends, obj)
          end
        rescue Exception => ex
          puts "System -> #{ex.message}"
        end
      end
    end
  end

  def add_plugin(filename)
    cb = Plugin.new(self, filename).event

    @callbacks[cb[:type]] ||= []
    @callbacks[cb[:type]] << cb[:blk]
  end

  private
  def callback(type, obj)
    @callbacks[type].each{|c|c.call(obj)} if @callbacks.key?(type)
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
end
