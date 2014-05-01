#!/bin/bash

# This script is written for personal use,
# it is mainly for bootstrapping a server
# with the utilites that i use and want
# on a newly installed Debian linux server.

# Usage:
# curl -k https://kradalby.no/bs.sh | bash

SUDO=''


# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
    if [ -x /usr/bin/sudo ]; then
        SUDO='sudo'
    else
        exit "You are not root, and sudo is not installed"
    fi
fi

# Written by a awesome person from dotKom
function progress() {
    if $VERBOSE
    then
        $@
    else
        cmd="$@"
        $@ &> /dev/null &
        pid=$!
        spinner='-\|/'

        i=0
        while kill -0 $pid &> /dev/null
        do
            i=$(( (i+1) %4 ))
            printf "\r\t%-${LJUST_COLS}.${LJUST_COLS}s %${RJUST_COLS}s" "${cmd}" "[ ${spinner:$i:1}${spinner:$i:1} ]"
            sleep .1
        done

        if [ $? -ne 0 ]
        then
            echo "return code $?";
        fi
        printf "\r\t%-${LJUST_COLS}.${LJUST_COLS}s %${RJUST_COLS}s\n" "${cmd}" "[ OK ]"
    fi
}

function update() {
    echo "Updating repositories and OS"
    progress $SUDO apt-get update
    progress $SUDO apt-get dist-upgrade -y 
}

function install_packages() {
    echo "Installing packages from apt"
    progress $SUDO apt-get install -y \
        tmux vim-nox python python3 git \
        htop zsh python-dev python-setuptools \
        ntp tree ncdu ack
}

function install_ohzsh() {
    echo "Installing Oh My ZSH for this user"
    progress curl -L http://install.ohmyz.sh | sh
    
    if [[ $EUID -ne 0 ]]; then
        echo "Installing Of My ZSH for root"
        progress $SUDO su -c curl -L http://install.ohmyz.sh | sh
    fi
}

function install_dotfiles() {
    echo "Installing dotfiles"
    mkdir ~/git
    progress git clone https://github.com/kradalby/dotfiles.git ~/git/dotfiles
    progress ~/git/dotfiles/deploy.sh

    
    if [[ $EUID -ne 0 ]]; then
        echo "Installing dotfiles for root"
        progress $SUDO su -c "git clone https://github.com/kradalby/dotfiles.git ~/git/dotfiles"
        progress $SUDO su -c "~/git/dotfiles/deploy.sh"
    fi
}

update
install_packages
install_ohzsh
install_dotfiles

