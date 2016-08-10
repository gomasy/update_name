module TwitterBot
  module Event
    def event_type
      {
        Twitter::Tweet => :tweet,
        Twitter::Streaming::DeletedTweet => :delete,
        Twitter::Streaming::FriendList => :friends,
        Twitter::Streaming::Event => :event
      }.freeze
    end

    def user_id(obj)
      case obj
      when Twitter::Tweet
        obj.user.id
      when Twitter::Streaming::DeletedTweet
        obj.user_id
      when Twitter::Streaming::Event
        obj.source.id
      end
    end
  end
end
