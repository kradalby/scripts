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

function add_repos() {
    echo "Adding thirdparty repos"
    echo "Adding nodejs repo"
    curl -sL https://deb.nodesource.com/setup | bash -

    echo "Adding nginx repo"
    curl http://nginx.org/keys/nginx_signing.key | apt-key add -
    echo "" >> /etc/apt/sources.list
    echo "# Nginx repos" >> /etc/apt/sources.list
    echo "deb http://nginx.org/packages/debian/ $1 nginx" >> /etc/apt/sources.list
    echo "deb-src http://nginx.org/packages/debian/ $1 nginx" >> /etc/apt/sources.list

    echo "Adding weechat source"
    echo "" >> /etc/apt/sources.list
    echo "# Weechat repos" >> /etc/apt/sources.list
    echo "deb http://debian.weechat.org $1 main" >> /etc/apt/sources.list


}

function install_packages() {
    echo "Installing packages from apt"
    $SUDO apt-get install -y \
        tmux vim-nox python python3 git \
        htop zsh python-dev python-setuptools \
        ntp tree ncdu ack-grep ssh mosh fail2ban \
        cu postfix lldpd lm-sensors apticron
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

function change_repos() {
    echo "Changing repositories from main to main contrib non-free"
    $SUDO sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list
}

function create_motd() {
    echo "Creating motd"
    curl --compressed "http://www.lemoda.net/games/figlet/figlet.cgi?text=$(hostname)&font=puffy&width=80" > /etc/motd
    echo "This server was bootstrapped with bs.sh (kradalby.no/bs.sh)" >> /etc/motd
}

function root_mail_recipiant() {
    echo "kradalby: kradalby@kradalby.no" >> /etc/aliases
    newaliases
}

function configure_sensors() {
    yes | sensors-detect
    /etc/init.d/kmod start
}

change_repos
add_repos "wheezy"
update
install_packages
install_ohzsh
install_dotfiles
create_motd
root_mail_recipiant
configure_sensors

