export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

export EDITOR=vim

source /etc/bash_completion.d/git
source /etc/bash_completion.d/ssh

sed -i "s/_HOSTIP_/$HOSTIP/" ~/.ssh/config

alias git=hub
alias open="hostexec open"
export BROWSER="hostexec open -a /Applications/Safari.app"
alias browse="$BROWSER"
alias docker-machine="hostexec docker-machine"

export DOCKER_MACHINE_NAME="dshell"
export DOCKER_TLS_VERIFY="1"
DOCKER_HOST_IP=`jq -r '.Driver.IPAddress' ~/.host/.docker/machine/machines/$DOCKER_MACHINE_NAME/config.json`
export DOCKER_HOST="tcp://"$DOCKER_HOST_IP":2376"
export DOCKER_CERT_PATH=$HOME"/.host/.docker/machine/machines/"$DOCKER_MACHINE_NAME
