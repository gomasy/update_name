module TwitterBot
  class Plugin
    attr_reader :event

    def initialize(account, filename)
      @account = account
      @event = {}

      self.instance_eval(File.read(filename))
    end

    def on_event(type, &blk)
      event[:type], event[:blk] = type, blk
    end

    def config
      @account.config
    end

    def twitter
      @account.rest
    end

    def stream
      @account.stream
    end

    def screen_name
      @account.user.screen_name
    end

    def user_id
      @account.user.id
    end
  end
end
