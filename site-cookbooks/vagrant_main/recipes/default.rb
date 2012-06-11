# vagrant_main script to configure virtual machine
# by Patrick Wyatt

# Useful documentation
# http://wiki.opscode.com/display/chef/Recipes
# http://wiki.opscode.com/display/chef/Resources


#============================================================================
# Disable password-based login to the vagrant account to reduce attack surface
# This is important because everyone knows the password to the vagrant account
execute "sudo passwd -d vagrant" do
  action :nothing
end.run_action(:run)


#============================================================================
# Run the most recent version of apt-get which may be required by some apt packages
execute "apt-get update -y" do
  action :nothing
end.run_action(:run)


#============================================================================
# Configure sshd to turn off password-based login
require_recipe 'openssh'
template "/etc/ssh/sshd_config" do
    source "sshd_config.erb"
    owner 'root'
    group 'root'
    mode '0600'
    notifies :restart, "service[ssh]"
end


#============================================================================
# Install cookbooks and packages requested by user
begin
  install = Chef::DataBag.load("install").first[1]
  install["recipes"].each do |recipe|
    require_recipe recipe
  end
  install["apt-packages"].each do |pkg|
      apt_package pkg do
      action :install
    end
  end
end


#============================================================================
# Create admin accounts
begin
  admins = []
  Chef::DataBag.load("admins").each do |login, admin|
    #==================================
    # add user to admins group
    admins << login

    #==================================
    # create user
    user(login) do
      uid       admin['uid']
      gid       admin['gid']
      shell     admin['shell']
      comment   admin['comment']
      home      "/home/#{login}"
      supports  :manage_home => true
    end

    #==================================
    # remove password-based login
    execute "sudo passwd -d #{login}" do
      action :nothing
    end.run_action(:run)

    #==================================
    # ssh: configure authorized_keys file and create rsa key
    directory "/home/#{login}/.ssh" do
      owner login
      group login
      mode '0700'     # 0600 does not work; directory traverse bit must be set
      recursive true
    end

    file "/home/#{login}/.ssh/authorized_keys" do
      owner login
      group login
      mode '0600'
      action :create
      content admin['authorized_keys']
    end

    execute "generate ssh keys for #{login}" do
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
    # get user dotfiles from git
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
   
  #==================================
  # Update admin group. Important: make sure vagrant user is still an admin!
  admins << "vagrant"
  group "admin" do
    members admins
  end

  #============================================================================
  # Enable first user to auto-login in XWindows (if ubuntu-desktop installed)
  directory "/etc/gdm" do
    owner 'root'
    group 'root'
    mode '0755'
  end

  file "/etc/gdm/custom.conf" do
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    content <<-END.gsub(/^ {4}/, '')
      [daemon]
      TimedLoginEnable=true
      AutomaticLoginEnable=true
      TimedLogin=#{admins[0]}
      AutomaticLogin=#{admins[0]}
      TimedLoginDelay=0
      DefaultSession=gnome
    END
  end

end
