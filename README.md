# Installation and configuration
---
Install software

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
Download and extract the virtual machine image

    :: Using vagrant box on Windows is painfully slow!
    :: no --> vagrant box add lucid64 http://files.vagrantup.com/lucid64.box
    :: Do this instead:
    set boxname=lucid64
    md %USERPROFILE%\.vagrant.d\boxes\%boxname%
    cd %USERPROFILE%\.vagrant.d\boxes\%boxname%
    curl http://files.vagrantup.com/%boxname%.box > %boxname%.7z
    7z x %boxname%.7z
    del %boxname%.7z


# Building Linux VM
---
Clone this repository and run!

    :: cd into your parent-of-repo directory
    git clone https://github.com/webcoyote/build-linux-vm.git
    cd build-linux-vm
    :: get cookbooks
    update.bat
    :: build virtual machine
    vagrant up
    :: several minutes from now... success!


# Git note
---
On Windows, it is necessary to configure repositories to use the git protocol instead of https
to avoid password prompts:

    git remote add origin git@github.com:webcoyote/build-linux-vm.git


