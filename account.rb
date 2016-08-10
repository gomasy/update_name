require "twitter"
require "./event.rb"

module TwitterBot
  class Account
    include TwitterBot::Event

    attr_accessor :config
    attr_reader :rest, :stream, :user, :log

    def initialize(token)
      @rest = Twitter::REST::Client.new(token)
      @stream = Twitter::Streaming::Client.new(token)
      @user = @rest.verify_credentials
      @config = token
      @callbacks = {}

      @log = Logger.new(OPTS["log-file"])
      @log.progname = @user.screen_name
    end

    def start
      loop do
        @stream.user do |obj|
          t = []
          t << Thread.new do extract(obj) end

          t.join
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
      if @callbacks.key?(type) && allowed?(obj)
        @callbacks[type].each do |c|
          c.call(obj)
        end
      end
    rescue Exception => e
      log.fatal %([Exception]<red>\n\t#{e}\n\t#{e.backtrace.join("\n\t")}</red>)
    end

    def extract(obj)
      callback(event_type[obj.class], obj)
    rescue Exception => e
      log.fatal %([Exception]<red>\n\t#{e}\n\t#{e.backtrace.join("\n\t")}</red>)
    end

    def allowed?(obj)
      obj.class != Twitter::Streaming::FriendList ?
        @config[:friends].include?(user_id(obj)) : true
    end
  end
end
