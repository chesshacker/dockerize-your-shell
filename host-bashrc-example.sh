
# set DOCKER_MACHINE_NAME to whatever you want to call your docker machine
# just make sure it matches what you put in shell/bashrc
DOCKER_MACHINE_NAME=dshell

# set DOCKER_IMAGE_NAME to whatever you like
DOCKER_IMAGE_NAME=dshell_image

# DOCKERFILE_PATH should point to the shell directory of this repository
# or wherever you are keeping the Dockerfile describing your shell container
DOCKERFILE_PATH=~/.dockerize-your-shell/shell

PS1='osx $ '

# this is to help find commands executed by ssh (non-interactive)
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# determine if connected over ssh
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=remote/ssh
else
  case $(ps -o comm= -p $PPID) in
         sshd|*/sshd) SESSION_TYPE=remote/ssh;;
  esac
fi

# only run these commands if logged in locally
if [ "$SESSION_TYPE" != "remote/ssh" ]; then
  docker-machine ls | grep "^$DOCKER_MACHINE_NAME" > /dev/null
  if [ $? -ne 0 ]; then
    echo "$DOCKER_MACHINE_NAME docker-machine not found. Attempting to create one."
    docker-machine create --driver virtualbox --virtualbox-memory 4096 --virtualbox-cpu-count 4 $DOCKER_MACHINE_NAME
  fi
  if [ "$(docker-machine status $DOCKER_MACHINE_NAME)" = "Stopped" ]; then
    echo "$DOCKER_MACHINE_NAME docker-machine is stopped. Attempting to start it."
    docker-machine start $DOCKER_MACHINE_NAME
    sleep 3
  fi
  eval "$(docker-machine env $DOCKER_MACHINE_NAME)"
  build_dshell="(cd $DOCKERFILE_PATH && docker build --build-arg USERNAME="$USER" --build-arg HOMEDIR="$HOME" -t $DOCKER_IMAGE_NAME .)"
  if [ -z "$(docker images -q $DOCKER_IMAGE_NAME)" ]; then
    if [ ! -d $DOCKERFILE_PATH ]; then
      git clone "https://github.com/steveortiz/dockerize-your-shell.git" ~/.dockerize-your-shell
    fi
    $build_dshell
  fi
  MYIP=`ifconfig vboxnet0 | grep 'inet ' | awk '{print $2}'`
  start_dshell="docker run -it --rm -v $HOME:$HOME/.host -v /var/run/docker.sock:/var/run/docker.sock -e HOSTIP=$MYIP $DOCKER_IMAGE_NAME"
  alias dshell=$start_dshell
  alias dbuild=$build_dshell
  alias dmrestart='docker-machine restart $DOCKER_MACHINE_NAME && sleep 3 && eval "$(docker-machine env $DOCKER_MACHINE_NAME)"'
  $start_dshell
fi
