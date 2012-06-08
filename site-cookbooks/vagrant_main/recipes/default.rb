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
    login = admin["id"]
    homedir = "/home/#{login}"
    user(login) do
      uid       admin['uid']
      gid       admin['gid']
      shell     admin['shell']
      comment   admin['comment']
      home      homedir
      supports  :manage_home => true
    end
    admins << login

    directory "#{homedir}/.ssh" do
      owner login
      group login
      mode '0700'     # 0600 does not work; directory traverse bit must be set
      recursive true
    end

    file "#{homedir}/.ssh/authorized_keys" do
      owner login
      group login
      mode "0600"
      action :create
      content admin['ssh_key']
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
