FROM postgres:14.2-alpine3.15

# ENV DOCKER true


# Installed apps
# USER root
# RUN apt update \
#     && apt install -y \
#     zsh \
#     vim \
#     exa \
#     bat
# ENV SHELL /bin/zsh

# Logging in as a rootless user
# ARG UID=1001
# ARG GID=1001
# RUN addgroup -g $GID rootless
# RUN adduser -u $UID -G rootless -D rootless
# USER rootless


# WORKDIR /home/rootless
# COPY ./base.zshenv .zshenv
# COPY ./base.zshrc .zshrc

# WORKDIR /home/rootless/src
