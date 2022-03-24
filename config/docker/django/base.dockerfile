FROM python:3.10-slim

ENV DOCKER true

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

USER root


# install apps for production
RUN apt update \
    && apt install -y \
    netcat


# install apps for development
RUN apt install -y \
    zsh \
    vim \
    exa \
    bat

ENV SHELL /bin/zsh


# install python libraries
WORKDIR /root
COPY ./requirements.txt ./
RUN pip install --upgrade pip \
    && pip install -r requirements.txt


# log in as a rootless user
ARG USERNAME
ARG UID
ARG GID

RUN useradd -u ${UID} -o -m ${USERNAME}
RUN groupmod -g ${GID} -o ${USERNAME}

USER ${USERNAME}

WORKDIR /home/${USERNAME}

COPY --chown=${USERNAME} ./base.zshenv ./.zshenv
COPY --chown=${USERNAME} ./base.zshrc ./.zshrc


# set entry point
COPY --chown=${USERNAME} ./entry_point.sh ./
RUN chmod u+x entry_point.sh



ENTRYPOINT ["../entry_point.sh", "/bin/zsh"]
