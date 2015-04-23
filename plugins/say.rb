require "cgi"
require "yaml"

FILE = "./abuse.yml".freeze

def load_table(file)
  @tbl = config["abuse"] = YAML.load_file(file)
end

def save_table(file)
  open(file, "w") do |f|
    YAML.dump(@tbl, f)
  end
end

def update_table(obj, cmd, data, tbl)
  case cmd
  when "add"
    tbl << data
    @tw = "@#{obj.user.screen_name} Just added #{data} to abuse list".freeze
  when "del"
    tbl.delete(data)
    @tw = "@#{obj.user.screen_name} Just deleted #{data} to abuse list".freeze
  end

  twitter.update(@tw, :in_reply_to_status_id => obj.id)
end

def abuse(obj, cmd, type, data)
  load_table(FILE)

  case type
  when "w" then update_table(obj, cmd, data, @tbl["word"])
  when "sn"
    data = twitter.friendships(data).first.id.freeze
    update_table(obj, cmd, data, @tbl["user"])
  end

  save_table(FILE)
end

def abuse_user?(id)
  @tbl["user"].include?(id)
end

def abuse_word?(word)
  @tbl["word"].include?(word)
end

def say(obj, str)
  if abuse_user?(obj.user.id)
    @tw = "@#{obj.user.screen_name} あなたはこのコマンドを使用する権限がありません".freeze
  elsif abuse_word?(str)
    @tw = "@#{obj.user.screen_name} この単語は禁止されています".freeze
  else
    @tw = str.freeze
  end

  twitter.update(@tw, :in_reply_to_status_id => obj.id)
end

on_event(:tweet) do |obj|
  say_ptn = /^(?!RT).*@#{screen_name}\ssay\s((.|\n)+)$/.freeze
  abuse_ptn = /^(?!RT).*@#{screen_name}\sabuse\s(.+?)\s(.+?):((.|\n)+)$/.freeze

  case CGI.unescapeHTML(obj.text)
  when say_ptn then say(obj, $1.sub(/@/, "@\u200b"))
  when abuse_ptn then abuse(obj, $1, $2, $3) if obj.user.id == user_id
  end
end
