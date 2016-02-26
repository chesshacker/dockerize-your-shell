FROM ubuntu:wily
MAINTAINER Steve Ortiz <steve@ortizaggies.com>

# these help to avoid warnings during some of the apt-get installs below
ENV TERM=xterm-256color
ENV DEBIAN_FRONTEND=noninteractive

# get up-to-date
RUN apt-get update \
  && apt-get -y upgrade

# install all the standard things
RUN apt-get install -y ubuntu-standard

# add git-core ppa so we can get the latest greatest git
RUN apt-get install -y software-properties-common \
  && add-apt-repository ppa:git-core/ppa \
  && apt-get update

# lets install this new git and a few other handy things
RUN apt-get install -y \
  git \
  build-essential \
  curl \
  sudo \
  vim \
  jq

# install docker
RUN apt-get install apt-transport-https ca-certificates \
  && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
  && echo "deb https://apt.dockerproject.org/repo ubuntu-wily main" > /etc/apt/sources.list.d/docker.list \
  && apt-get update \
  && apt-get install -y docker-engine

# install the latest hub
RUN HUB_URL="https://github.com"`curl -sL https://github.com/github/hub/releases/latest | grep hub-linux-amd64 | grep -o -P '(?<=href=")[^"]+'` \
  && mkdir -p /tmp/hub \
  && (cd /tmp/hub && curl -fsSL $HUB_URL | tar xzf -) \
  && (cd /tmp/hub/hub-* && ./install) \
  && rm -rf /tmp/hub

# add some scripts to the system that bashrc expects
ADD hostexec /usr/local/bin/hostexec
ADD bash-completion-git /etc/bash_completion.d/git
ADD bash-completion-ssh /etc/bash_completion.d/ssh

# setup system bashrc
ADD system-bashrc.sh /etc/bash-dockerize-my-shell.sh
RUN echo "source /etc/bash-dockerize-my-shell.sh" >> /etc/bash.bashrc

# add files to the skel directory
ADD ssh-config /etc/skel/.ssh/config

# at least USERNAME must be passed in as a build-arg
ONBUILD ARG USERNAME
ONBUILD ARG HOMEDIR=/Users/$USERNAME

# when you run this docker container, you need to mount this directory
ONBUILD ENV MOUNTDIR=$HOMEDIR/.host

# create the user and setup sudo
ONBUILD RUN mkdir /Users \
  && useradd -d $HOMEDIR -ms /bin/bash $USERNAME \
  && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# link to content on .host -- feel free to add to this list
ONBUILD ENV LINK_HOST_DIRS="Desktop Downloads .config .docker"
ONBUILD RUN chmod 700 $HOMEDIR/.ssh \
  && ln -sf $MOUNTDIR/.ssh/id_rsa $HOMEDIR/.ssh/id_rsa \
  && ln -sf $MOUNTDIR/.ssh/known_hosts $HOMEDIR/.ssh/known_hosts \
  && for directory in $LINK_HOST_DIRS; do \
    ln -sf $MOUNTDIR/$directory $HOMEDIR/$directory; \
  done \
  && chown -R $USERNAME: $HOMEDIR

# define how it is executed
ONBUILD USER $USERNAME
ONBUILD WORKDIR $HOMEDIR
CMD ["/bin/bash"]
