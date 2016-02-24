#!/bin/bash

# curl -sL https://raw.githubusercontent.com/steveortiz/dockerize-your-shell/master/setup.sh | bash -

# add environment variables and script .bashrc
echo "# Dockerize your Shell" >> ~/.bashrc
echo "DOCKER_MACHINE_NAME=dshell" >> ~/.bashrc
echo "DOCKER_IMAGE_NAME=dshell_image" >> ~/.bashrc
echo "DOCKERFILE_PATH=~/.dockerize-your-shell" >> ~/.bashrc
echo "source ~/.dockerize-your-shell/dockerize-your-shell.sh" >> ~/.bashrc

mkdir -p ~/.dockerize-your-shell
GIT_URL=https://raw.githubusercontent.com/steveortiz/dockerize-your-shell/master
curl -sL $GIT_URL"/dockerize-your-shell.sh" -o ~/.dockerize-your-shell/dockerize-your-shell.sh
# TODO: check for a dockerfile before possibly writing over it!
curl -sL $GIT_URL"/example/Dockerfile" -o ~/.dockerize-your-shell/Dockerfile
