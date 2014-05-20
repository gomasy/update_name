# coding: utf-8

require "yaml"
require "./account.rb"

tokens = YAML.load_file("./keys.yml")
account = Account.new(tokens)
files = Dir.glob(File.expand_path("../plugins/*.rb", __FILE__))
files.each do |file|
  account.instance_eval(File.read(file))
end
account.start
