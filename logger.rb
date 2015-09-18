require "logger"
require "termcolor"

module TwitterBot
  class Logger < Logger
    LEVEL = {
      "fatal" => FATAL,
      "error" => ERROR,
      "warn" => WARN,
      "info" => INFO,
      "debug" => DEBUG
    }.freeze

    def initialize(logdev, shift_age = 0, shift_size = 1048576)
      super

      @level = LEVEL[OPTS["log-level"]]
      @formatter = proc do |sev, date, name, msg|
        fmt = %(<green>[#{date}] </green>#{sev} -- #{name} #{msg}\n).termcolor

        if !stdout?(OPTS["log-file"]) then fmt.gsub(/\e\[(\d+;?)+m/, "")
        else fmt end
      end
    end

    def stdout?(file)
      file == STDOUT || file == "/dev/stdout"
    end
  end
end
