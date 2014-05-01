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

function update() {
    echo "Updating repositories and OS"
    $SUDO apt-get update
    $SUDO apt-get dist-upgrade -y 
}

function install_packages() {
    echo "Installing packages from apt"
    $SUDO apt-get install -y \
        tmux vim-nox python python3 git \
        htop zsh python-dev python-setuptools \
        ntp tree ncdu ack ssh mosh
}

function install_ohzsh() {
    echo "Installing Oh My ZSH for this user"
    curl -L http://install.ohmyz.sh | sh
    
    if [[ $EUID -ne 0 ]]; then
        echo "Installing Of My ZSH for root"
        $SUDO su -c curl -L http://install.ohmyz.sh | sh
    fi
}

function install_dotfiles() {
    echo "Installing dotfiles"
    mkdir ~/git
    git clone https://github.com/kradalby/dotfiles.git ~/git/dotfiles
    ~/git/dotfiles/deploy.sh

    
    if [[ $EUID -ne 0 ]]; then
        echo "Installing dotfiles for root"
        $SUDO su -c "git clone https://github.com/kradalby/dotfiles.git ~/git/dotfiles"
        $SUDO su -c "~/git/dotfiles/deploy.sh"
    fi
}

update
install_packages
install_ohzsh
install_dotfiles

