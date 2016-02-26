FROM steveortiz/dockerize-your-shell:0.1
MAINTAINER Steve Ortiz <steve@ortizaggies.com>

# install anything you like here...
# for example: install the ping utility
RUN sudo apt-get install -y iputils-ping

# any directories listed here will be linked from the shell to the host
ENV LINK_HOST_DIRS="Desktop Downloads"
RUN for directory in $LINK_HOST_DIRS; do \
    ln -sf $MOUNTDIR/$directory $HOMEDIR/$directory; \
  done

ADD bashrc $HOMEDIR/.bashrc
