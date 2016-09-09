FROM base/archlinux:latest
MAINTAINER Gomasy <nyan@gomasy.jp>

# Upgrade and install packages
RUN pacman -Sy --noconfirm archlinux-keyring
RUN pacman -Syu --noconfirm
RUN pacman-db-upgrade
RUN update-ca-trust
RUN pacman -Sgq base | sed -e ':loop; N; $!b loop; s/\n/ /g' | sed -e 's/linux //' | xargs pacman -S --noconfirm --needed base-devel cowsay jq php ruby

# Delete unnecessary files
RUN yes | pacman -Scc
RUN find / -name "*.pacnew" | xargs rm
