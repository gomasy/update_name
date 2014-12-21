# coding: utf-8

module TwitterBot
  class Plugin
    attr_reader :event

    def initialize(account, filename)
      @account = account

      self.instance_eval(File.read(filename))
    end

    def on_event(type, &blk)
      @event = { :type => type, :blk => blk }
    end

    def twitter
      @account.rest
    end

    def screen_name
      @account.user.screen_name
    end

    def user_id
      @account.user.id
    end
  end
end
