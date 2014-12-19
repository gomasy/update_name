#!/usr/bin/ruby
# coding: utf-8

require "yaml"

require "./account.rb"
require "./plugin.rb"

tokens = YAML.load_file("./keys.yml")
tokens.each do |token|
  @threads ||= []
  @threads << Thread.new do
    account = Account.new(token)
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
