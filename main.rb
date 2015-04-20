#!/usr/bin/ruby

require "yaml"

require "./account.rb"
require "./plugin.rb"

tokens = YAML.load_file("./config.yml")
tokens.each do |token|
  token.each_value do |v|
    v.freeze
  end

  @threads ||= []
  @threads << Thread.new do
    account = TwitterBot::Account.new(token)
    files = Dir.glob(File.expand_path("../plugins/*.rb", __FILE__))
    files.each do |file|
      account.add_plugin(file)
    end
    account.start
  end
end

@threads.each do |thread|
  thread.join
end
