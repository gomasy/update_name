module TwitterBot
  class Plugin
    attr_reader :event

    def initialize(account, filename)
      @account = account
      @event = {}

      self.instance_eval(File.read(filename))
    end

    def on_event(type, &blk)
      @event = { :type => type, :blk => blk }.freeze
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

    def log
      @account.log
    end

    def screen_name
      @account.user.screen_name.freeze
    end

    def user_id
      @account.user.id.freeze
    end
  end
end
