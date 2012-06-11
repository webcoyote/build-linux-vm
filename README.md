# Overview
---
This project is designed to make it easy to build Linux virtual machines on Windows
for use as dev-environment servers or for use as a Linux desktop.

I've written these instructions under the assumption that you're running vanilla
Windows, so this should work even if you don't have any of the pre-requisites yet.

This project is built with Vagrant, Chef, Librarian and VirtualBox.


# Features
---
* Configures your user account with administrative access
* SSH key-based login; remote access via passwords disabled
* Password-less sudo (but you can change it if you like)
* Password-less login to deskstop (if you choose to install Ubuntu-desktop)
* Installs your "dotfiles" from a separate git repository
* Installs the recipes and apt-get packages you specify
* Separation of code and data; user-specific data stored in data-bags
* Easy maintenance of chef recipes using librarian-chef

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


# Errors
---

* Mounting error:

> The following SSH command responded with a non-zero exit status.
    
> Vagrant assumes that this means the command failed!
    
> mount -t vboxsf -o uid=`id -u vagrant`,gid=`id -g vagrant` v-csc-2 /tmp/vagrant-chef-1/chef-solo-2/cookbooks

    SOLUTION: Run "librarian-chef update" on the Windows host system and then run "vagrant reload"


# Git note
---
On Windows, it is necessary to configure repositories to use the git protocol instead of https
to avoid password prompts:

    git remote add origin git@github.com:webcoyote/build-linux-vm.git

I mention this because, by default GitHub suggests HTTPS-based URLs instead of GIT-based, and
it took me a while to figure out WTF I had to use a password when my SSH key was there!


# Mea culpa
---
If this doesn't work it is probably my fault, I would very much appreciate your feedback
so I can fix it for you :)
