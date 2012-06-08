# Cookbook Name:: openssh
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['sshd']['Port'] = "22"
default['sshd']['ListenAddressV6'] = "::"
default['sshd']['ListenAddressV4'] = "0.0.0.0"

# Valid Protocol values: "1", "2", "2,1"
default['sshd']['Protocol'] = "2"

# Valid AddressFamily arguments: 'any', 'inet' (IPv4 only), 'inet6' (ipv6 only)
default['sshd']['AddressFamily'] = "any"

default['sshd']['HostKeyRSA'] = "/etc/ssh/ssh_host_rsa_key"
default['sshd']['HostKeyDSA'] = "/etc/ssh/ssh_host_dsa_key"

default['sshd']['UsePrivilegeSeparation'] = "yes"

default['sshd']['KeyRegenerationInterval'] = "3600"
default['sshd']['ServerKeyBits'] = "768"

default['sshd']['SyslogFacility'] = "AUTHPRIV"
default['sshd']['LogLevel'] = "INFO"

default['sshd']['LoginGraceTime'] = "120"

# For security! Do not change! PatW
default['sshd']['PermitRootLogin'] = "no"

default['sshd']['StrictModes'] = "yes"
default['sshd']['MaxAuthTries'] = "6"

default['sshd']['RSAAuthentication'] = "yes"
default['sshd']['PubkeyAuthentication'] = "yes"

default['sshd']['IgnoreRhosts'] = "yes"
default['sshd']['RhostsRSAAuthentication'] = "no"
default['sshd']['HostbasedAuthentication'] = "no"
default['sshd']['IgnoreUserKnownHosts'] = "no"

default['sshd']['PermitEmptyPasswords'] = "no"

default['sshd']['ChallengeResponseAuthentication'] = "no"

default['sshd']['GSSAPIAuthentication'] = "no"
default['sshd']['GSSAPICleanupCredentials'] = "yes"

# For security! SSH keys only, no passwords! PatW
default['sshd']['PasswordAuthentication'] = "no"

default['sshd']['X11Forwarding'] = "no"
default['sshd']['X11DisplayOffset'] = "10"
default['sshd']['PrintMotd'] = "no"
default['sshd']['PrintLastLog'] = "yes"
default['sshd']['TCPKeepAlive'] = "yes"

default['sshd']['AcceptEnv'] = "LANG LC_*"

default['sshd']['Subsystem'] = "sftp /usr/lib/openssh/sftp-server"

default['sshd']['UsePAM'] = "yes"
default['sshd']['UseDNS'] = "no"
