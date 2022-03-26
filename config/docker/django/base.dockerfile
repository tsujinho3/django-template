# *** production builder ***
FROM python:3.10-slim as builder_prod

ARG USERNAME
ARG UID
ARG GID

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

USER root
WORKDIR /root

# install apps
RUN apt update \
    && apt install -y --no-install-recommends\
    netcat

#  install python libraries
COPY ./requirements.txt ./
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# create rootless user
RUN useradd -u ${UID} -o -m ${USERNAME} \
    && groupmod -g ${GID} -o ${USERNAME}


# *** development builder ***
FROM builder_prod as builder_dev

ARG USERNAME

ENV DOCKER true

USER root

# install apps for development
RUN apt install -y \
    zsh \
    vim \
    exa \
    bat

ENV SHELL /bin/zsh

USER ${USERNAME}
WORKDIR /home/${USERNAME}

COPY --chown=${USERNAME} ./base.zshenv ./.zshenv
COPY --chown=${USERNAME} ./base.zshrc ./.zshrc


# *** final output ***
FROM builder_dev

ARG USERNAME

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# set entry point
COPY --chown=${USERNAME} ./entry_point.sh ./
RUN chmod u+x entry_point.sh

ENTRYPOINT ["../entry_point.sh", "/bin/zsh"]
