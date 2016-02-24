# Dockerize your Shell

I install a lot of different programming languages and utilities on my Mac.
Doing this manually is painful, so I made a massive Dockerfile to describe my
entire dev environment and keep it under configuration control. Now when I start
up a terminal shell, it actually launches a docker container that I use for
day-to-day tasks.

To make this setup more user-friendly, I taught the container to run certain
commands directly on my Mac instead of the container, so commands like `open .`
work from the container as they would if you ran them directly on your Mac. Look
at the aliases in bashrc to see how it works and customize the commands.
`docker` commands also work from the container as if it was on your Mac.

Since you probably have a different list of relevant programming languages and
utilities than I do, I omitted my specifics and kept it basic. I did install the
latest git and hub tools, but this is only meant to get you started. Install
whatever you like and make the Dockerfile your own.

## Getting Started

* make a copy of your ~/.bashrc file somewhere safe
* replace the contents of your ~/.bashrc with host-bashrc-example.sh
* customize the environment variables at the top of the bashrc file
* open a new terminal and hopefully after some one-time initialization, you will
  be greeted by your new shell

## Usage

By default, you are brought straight into the dockerized shell. Should you exit
the shell, you will see a `osx $` prompt. From this prompt, you have a few new
aliases.

* `dshell` will launch a new instance of your dockerized shell.
* `dbuild` will rebuild your dockerized shell image. Do this after changing your
  shell's Dockerfile
* `dmrestart` should be used if your docker machine gets out of sorts. Sometimes
  this can happen when changing networks. After a `dmrestart`, you should be
  able to get back in your shell with `dshell`
* Within the shell, you also have a few aliases defined. `open`, `atom` and
  `mate` are a few handy ones. They run a shell script called `hostexec` that
  ssh's to your Mac, changes to the equivalent directory and runs the specified
  command... so it appears as though the command was run directly on your Mac.

## Dependencies

`hostexec` works through the magic of ssh. It assumes you have setup ssh keys.
Specifically, the Dockerfile tries to create a symbolic link to ~/.ssh/id_rsa.
If you don't have such a file, you can generate one by running `ssh-keygen` and
accepting all the defaults. For ssh to work, you must also enable Remote Login
on the Sharing pane of the System Preferences. When you have both of these in
place, you should be able to run `ssh localhost` successfully without being
prompted for a password.

It also assumes you have a recent version of [Docker
installed.](https://docs.docker.com/mac/step_one/)

In theory you should be able to do something similar on other platforms, but
this assumes you are running Mac OS X.

It also assumes you keep your git and hub configuration in the ~/.config
directory. If you use ~/.gitconfig instead, you can run
`mkdir -p ~/.config/git && mv ~/.gitconfig ~/.config/git/config` to fix it.

## Customization

In addition to apt-get installing more things, you may want to symbolically
link more directories from your host to your dockerized shell. In my personal
version of this, I link things like Dropbox, Google Drive and others. Look in
the Dockerfile at LINK_HOST_DIRS.

## Issues

I have been using this setup for the past couple of months, and so far it has
worked pretty well for me.

That said, this is my first attempt to share my setup with others, and I
modified my scripts and Dockerfile heavily in the process. There also isn't much
in the way of error checking or helpful error messages. So please create a
GitHub issue if you are having problems with anything. Thank you!
