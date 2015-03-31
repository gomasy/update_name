require "twitter"

module TwitterBot
  class Account
    attr_accessor :config
    attr_reader :rest, :stream, :user

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
            t << Thread.new do extract_obj(obj) end
            t.join
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
      @callbacks[type].each do |c|c.call(obj) end if @callbacks.key?(type) && is_allowed?(obj)
    end

    def extract_obj(obj)
      case obj
      when Twitter::Tweet then callback(:tweet, obj)
      when Twitter::Streaming::DeletedTweet then callback(:delete, obj)
      when Twitter::Streaming::Event
        update_follow_list(obj)
        callback(:event, obj)
      when Twitter::Streaming::FriendList
        init_follow_list(obj)
        callback(:friends, obj)
      end
    rescue Exception => e
      puts "Exception -> #{e.message}"
    end

    def get_user_id(obj)
      case obj
      when Twitter::Tweet then obj.user.id
      when Twitter::Streaming::DeletedTweet then obj.user_id
      when Twitter::Streaming::Event then obj.source.id
      end
    end

    def is_allowed?(obj)
      is_pmt = (obj.class == Twitter::Streaming::FriendList ? true : false)
      if !is_pmt
        user_id = get_user_id(obj)
        @config["followings"].each do |id|
          if user_id == id
            is_pmt = true
            break
          end
        end
      end

      is_pmt
    end

    def do_follow(id, sn)
      if id != @user.id && @config["auto_fb"]
        @rest.follow(id)
        @config["followings"] << id
        STDERR.puts "System -> Followed to @#{sn}"
      end
    end

    def init_follow_list(obj)
      @config["followings"] = obj
      @config["followings"] << @user.id
    end

    def update_follow_list(obj)
      case obj.name
      when :follow then do_follow(obj.source.id, obj.source.screen_name)
      when :unfollow then @config["followings"].delete(obj.target.id)
      end
    end
  end
end
