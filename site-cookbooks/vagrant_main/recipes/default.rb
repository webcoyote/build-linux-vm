# vagrant_main script to configure virtual machine
# by Patrick Wyatt

# Useful documentation
# http://wiki.opscode.com/display/chef/Recipes
# http://wiki.opscode.com/display/chef/Resources


# Disable password-based login to the vagrant account to reduce attack surface
# This is important because everyone knows the password to the vagrant account
execute "sudo passwd -d vagrant" do
  action :nothing
end.run_action(:run)


# Run the most recent version of apt-get which may be required by some apt packages
execute "apt-get update -y" do
  action :nothing
end.run_action(:run)


# Install chef cookbooks desired by user
%w{build-essential apt git zsh}.each do |pkg|
  require_recipe pkg
end


# Configure sshd to turn off password-based login
require_recipe 'openssh'
template "/etc/ssh/sshd_config" do
    source "sshd_config.erb"
    owner "root"
    group "root"
    mode "0600"
    notifies :restart, "service[ssh]"
end


# Install apt packages desired by user
node[:apt_packages].each do |pkg|
  apt_package pkg do
    action :install
  end
end


#============================================================================
# Create admin accounts
begin
  admins = []
   
  # search for all items in the 'admins' data bag and loop over them
  node[:admins].each do |admin|

    #==================================
    # create user
    login = admin["id"]
    user(login) do
      uid       admin['uid']
      gid       admin['gid']
      shell     admin['shell']
      comment   admin['comment']
      home      "/home/#{login}"
      supports  :manage_home => true
    end
    admins << login

    #==================================
    # ssh keys
    directory "/home/#{login}/.ssh" do
      owner login
      group login
      mode '0700'     # 0600 does not work; directory traverse bit must be set
      recursive true
    end

    file "/home/#{login}/.ssh/authorized_keys" do
      owner login
      group login
      mode "0600"
      action :create
      content admin['ssh_key']
    end

    execute "generate ssh skys for #{login}." do
      user login
      creates "/home/#{login}/.ssh/id_rsa.pub"
      command "ssh-keygen -t rsa -q -f /home/#{login}/.ssh/id_rsa -P \"\""
    end

    #==================================
    # zsh stuff
    git "/home/#{login}/.oh-my-zsh" do
      repository "git://github.com/robbyrussell/oh-my-zsh.git"
      user login
      group login
      reference "master"
      action :sync
    end

    #==================================
    # get dotfiles
    log "[dotfiles] Uploading dotfiles for #{login} from #{admin['dotfiles']['repo']} to /home/#{login}/.my_dotfiles" do
      level :info
    end
    
    git "/home/#{login}/.my_dotfiles" do
      repository admin['dotfiles']['repo']
      user login
      group login
      action :sync
      not_if { admin['dotfiles']['repo'].nil? }
      only_if {File.directory?("/home/#{login}")}
    end
    
    admin['dotfiles']['files'].each do |entry|
      link "/home/#{login}/#{entry}" do
        owner login
        group login
        to "/home/#{login}/.my_dotfiles/#{entry}"
        only_if {File.directory?("/home/#{login}")}
      end
    end

    #==================================
    # create dev directory
    directory "/home/#{login}/dev" do
      owner login
      group login
      mode '0700'
      recursive true
    end

  end
   
  # Create an "admins" group on the system
  # You might use this group in the /etc/sudoers file
  # to provide sudo access to the admins
  group "admins" do
    gid 999
    members admins
  end
end


