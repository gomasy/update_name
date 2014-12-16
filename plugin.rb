# coding: utf-8

class Plugin
  def initialize(account, filename)
    @account = account

    self.instance_eval(File.read(filename))
  end

  def on_event(event, &blk)
    @account.register_callback(event, &blk)
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
