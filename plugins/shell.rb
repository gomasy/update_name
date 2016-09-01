require "cgi"

def docker_run(cmd)
  `docker run -it --rm base/archlinux /bin/sh -c "#{cmd.gsub(/"|'/, "\'")} 2>&1"`
end

on_event(:tweet) do |obj|
  if CGI.unescapeHTML(obj.text) =~ /^(?!RT).*@#{screen_name}\sshell:\s?((.|\n)+?)$/
    r = docker_run($1)

    if "@#{obj.user.screen_name} #{r}".length > 140
      tw = "@#{obj.user.screen_name} ...#{r[obj.user.screen_name.length + r.length - 135..r.length]}"
    else
      tw = "@#{obj.user.screen_name} #{r}"
    end

    twitter.update(tw, :in_reply_to_status_id => obj.id)
  end
end
