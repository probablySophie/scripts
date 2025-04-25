
FROM registry.opensuse.org/devel/bci/tumbleweed/images/opensuse/tumbleweed:latest

ARG USER_NAME=testuser
ARG USER_ID=1000
ARG GROUP_ID=1000

ARG BASH_ENV="/home/$USER_NAME/.bash_env"

RUN zypper in -y wget awk git
RUN groupadd -g $GROUP_ID -o $USER_NAME
RUN useradd -m -u $USER_ID -g $GROUP_ID -o -s /bin/bash $USER_NAME

RUN touch .nvmrc
RUN chown $USER_NAME .nvmrc

USER $USER_NAME

RUN touch $BASH_ENV
RUN echo ". $BASH_ENV" >> ~/.bashrc
RUN echo "export NVM_DIR='/home/$USER_NAME/.nvm'" >> ~/.bashrc

RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | PROFILE="$BASH_ENV" bash
RUN echo node > .nvmrc

RUN source ~/.bashrc && nvm install
# Corepack for yarn
RUN source ~/.bashrc && npm i --location=global corepack
