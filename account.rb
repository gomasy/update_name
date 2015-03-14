require "twitter"

module TwitterBot
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
        begin
          @stream.user do |obj|
            t = []
            t << Thread.new{extract_obj(obj)}
            t.join
          end
        rescue Exception => ex
          puts "System -> #{ex.message}"
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

    def extract_obj(obj)
      case obj
      when Twitter::Tweet
        callback(:tweet, obj) if is_allowed?(obj.user.id)
      when Twitter::Streaming::DeletedTweet
        callback(:delete, obj) if is_allowed?(obj.user_id)
      when Twitter::Streaming::Event
        callback(:event, obj) if is_allowed?(obj.source.id)
      when Twitter::Streaming::FriendList
        @followings = obj
        @followings << user.id
        callback(:friends, obj)
      end
    end

    def is_allowed?(user_id)
      permit = false
      @followings.each do |id|
        if user_id == id
          permit = true
          break
        end
      end
      return permit
    end
  end
end
