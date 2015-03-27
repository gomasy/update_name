require "twitter"

module TwitterBot
  class Account
    attr_accessor :config
    attr_reader :rest, :user

    def initialize(config)
      @rest = Twitter::REST::Client.new(config)
      @stream = Twitter::Streaming::Client.new(config)
      @user = @rest.verify_credentials
      @config = config
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
          STDERR.puts "Exception -> #{ex.message}"
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
        if is_allowed?(obj.source.id) || obj.name == :follow || obj.name == :unfollow
          update_follow_list(obj)
          callback(:event, obj)
        end
      when Twitter::Streaming::FriendList
        init_follow_list(obj)
        callback(:friends, obj)
      end
    end

    def is_allowed?(user_id)
      permit = false
      @config["followings"].each do |id|
        if user_id == id
          permit = true
          break
        end
      end

      permit
    end

    def init_follow_list(obj)
      @config["followings"] = obj
      @config["followings"] << @user.id
    end

    def update_follow_list(obj)
      case obj.name
      when :follow
        if obj.source.id != @user.id && @config["auto_fb"]
          @rest.follow(obj.source.id)
          @config["followings"] << obj.source.id
        end
      when :unfollow
        @config["followings"].delete(obj.target.id)
      end
    end
  end
end
