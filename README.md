# Overview
---
This project is designed to make it easy to build Linux virtual machines on Windows.
It utilizes Vagrant, Chef and VirtualBox, but it's pretty dang easy if
you follow the instructions below.

I've written these instructions under the assumption that you're running vanilla Windows,
so this should work even if you don't have any of the pre-requisites.

If this doesn't work, I would very much appreciate your feedback so I can fix it for you :)


# Installation and configuration
---
Install software (and make sure they're in the PATH, m'kay)

* [Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads)

* [7zip](http://www.7-zip.org/download.html)

* [Git](http://git-scm.com/download)

* [Ruby(Windows)](http://rubyinstaller.org/downloads/)

Install Ruby gems

    gem install bundler
    gem install vagrant
    gem install librarian

Configure git

    git config --global user.name "Your Name Here"
    git config --global user.email "your_email@example.com"

[Generate ssh keys](https://help.github.com/articles/generating-ssh-keys)


# Download virtual machine image
---
Download and extract the virtual machine image by pasting these
commands into a command-shell (cmd.exe).

    :: Using the "vagrant box" command on Windows is painfully slow because
    :: the decompressor is written in Ruby. So let's simulate this command
    ::instead: "vagrant box add lucid64 http://files.vagrantup.com/lucid64.box
    set boxname=lucid64
    md %USERPROFILE%\.vagrant.d\boxes\%boxname%
    cd %USERPROFILE%\.vagrant.d\boxes\%boxname%
    curl http://files.vagrantup.com/%boxname%.box > %boxname%.7z
    7z x %boxname%.7z
    del %boxname%.7z


# Preparing the repository
---
Clone this repository (the one you're looking at right now):

    :: cd into your parent-of-repo directory
    git clone https://github.com/webcoyote/build-linux-vm.git
    cd build-linux-vm


# Edit the configuration files
---
These files are the ones you'll want to edit to configure the system as you like it.

* data_bags\admins\admins.json - which administrative users to create
* data_bags\install\install.json - which recipes and apt-packages to install
* Cheffile - which recipes to download for installation by install.json
* Vagrantfile - reconfigure virtual machine parameters (bridged vs. NAT networking, etc.)


# Build the Virtual Machine - finally!
    :: update chef cookbooks
    librarian-chef update

    :: build virtual machine
    vagrant up

    :: ... several minutes from now: success!


# Git note
---
On Windows, it is necessary to configure repositories to use the git protocol instead of https
to avoid password prompts:

    git remote add origin git@github.com:webcoyote/build-linux-vm.git


