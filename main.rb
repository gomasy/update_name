#!/usr/bin/ruby
# coding: utf-8

require "twitter"
require "yaml"
require "cgi"

tokens = YAML.load_file("keys.yml")

@rest_client = Twitter::REST::Client.new do |config|
  config.consumer_key               = tokens["consumer_key"]
  config.consumer_secret            = tokens["consumer_secret"]
  config.access_token               = tokens["oauth_token"]
  config.access_token_secret        = tokens["oauth_token_secret"]
end

stream_client = Twitter::Streaming::Client.new do |config|
  config.consumer_key               = tokens["consumer_key"]
  config.consumer_secret            = tokens["consumer_secret"]
  config.access_token               = tokens["oauth_token"]
  config.access_token_secret        = tokens["oauth_token_secret"]
end

def update_name(status, name)
  @found = false
  @allowed_user.length.times do |i|
    if @allowed_user[i] == status.user.id
      @found = true
      break
    end
  end
  if @found
    @rest_client.update_profile(:name => name)
    @rest_client.update(
      "@#{status.user.screen_name} さんのご要望により \"#{name}\" へ改名しました",
      :in_reply_to_status_id => status.id
      )
  end
rescue Twitter::Error::Forbidden => ex
  @rest_client.update(
    "@#{status.user.screen_name} #{ex.message}",
    :in_reply_to_status_id => status.id
  )
end

loop do
  begin
    stream_client.user do |object|
      case object
      when Twitter::Streaming::FriendList
        @allowed_user = object
      when Twitter::Tweet
        tweet = CGI.unescapeHTML(object.text.gsub(/@|＠/, "(at)"))
        if tweet =~ /^(?!.*RT).*\(at\)#{tokens["screen_name"]}\supdate_name\s(.+?)$/
          update_name(object, $1)
        elsif tweet =~ /^(?!.*RT)(.+?)(?:\(\s*\(at\)#{tokens["screen_name"]}\s*\)|（\s*\(at\)#{tokens["screen_name"]}\s*）)$/
          update_name(object, $1)
        end
      end
    end
  rescue => ex
    puts "System -> #{ex.message}"
    sleep(5)
  end
end
