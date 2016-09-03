require "cgi"

def docker_run(cmd)
  `docker run -it --rm base/archlinux /bin/timeout 1m /bin/sh -c "#{cmd.gsub(/"|'/, "\'")} 2>&1"`
end

on_event(:tweet) do |obj|
  if CGI.unescapeHTML(obj.text) =~ /^(?!RT).*@#{screen_name}\sshell:\s?((.|\n)+?)$/
    log.info %([System] Issued command: '#{$1}' by @#{obj.user.screen_name})
    tw = "@#{obj.user.screen_name} "
    r = docker_run($1)

    if tw.length + r.length > 140
      tw << "...#{r[obj.user.screen_name.length + r.length - 135..r.length]}"
    else
      tw << r
    end

    twitter.update(tw, :in_reply_to_status_id => obj.id)
  end
end
