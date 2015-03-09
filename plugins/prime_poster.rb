require "./lib/prime.rb"

def prime_post(obj, value)
  prime = Prime.factor(value)
  if !prime[0]
    @div = ""
    prime[1].each{|s|@div<<"#{s}*"}
    twitter.update(
      "@#{obj.user.screen_name} #{value} は素数じゃないぞ (#{@div[0..@div.length - 2]})",
      :in_reply_to_status_id => obj.id
    )
  else
    twitter.update(
      "@#{obj.user.screen_name} #{value} は素数だぞ",
      :in_reply_to_status_id => obj.id
    )
  end
rescue ArgumentError
  twitter.update(
    "@#{obj.user.screen_name} 値が不正です。(2 - 18446744073709551615)",
    :in_reply_to_status_id => obj.id
  )
end

on_event(:tweet) do |obj|
  ptn = /^(?!RT).*#{screen_name}\s+(\d+)$/
  if obj.text =~ ptn
    prime_post(obj, $1.to_i)
  end
end
