FROM base/archlinux:latest
MAINTAINER Gomasy <nyan@gomasy.jp>

# Upgrade and install packages
RUN pacman -Sy --noconfirm archlinux-keyring
RUN pacman -Syu --noconfirm
RUN pacman-db-upgrade
RUN update-ca-trust

# Install some packages
RUN pacman -S --noconfirm cowsay jq

# Delete unnecessary files
RUN pacman -Scc --noconfirm
RUN find / -name "*.pacnew" | xargs rm
