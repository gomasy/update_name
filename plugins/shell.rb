require "cgi"
require "tmpdir"

def docker_run(cmd)
  Dir.mktmpdir do |dir|
    File.open("#{dir}/input.sh", "w", 0755) do |file|
      file.puts cmd
    end

    `docker run -it --rm -v #{dir}:/script base/archlinux /bin/timeout 1m /bin/sh -c '/script/input.sh 2>&1'`
  end
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
