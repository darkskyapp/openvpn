# Rakefile for generating server and client OpenVPN certificates.
#
# Copyright:: 2009, Opscode, Inc
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

if ! defined?(ENV['EASY_RSA'])
  puts "Source the vars file first and try again."
  exit 1
end

desc "Create server openvpn keys."
task :server do
  Dir.chdir(ENV['PWD'])
  puts "* Clean up existing keys"
  sh %{./clean-all}
  puts "* Generate DH"
  sh %{./build-dh}
  puts "* Generate CA"
  sh %{./pkitool --initca}
  puts "* Generate Server key"
  sh %{./pkitool --server server}
end  

desc "Create a ZIP file for the specified user in /tmp."
task :client do
  Dir.chdir(ENV['PWD'])
  if (ENV['KEY_DIR'] == nil) 
    raise "Source 'vars' file and try again."
    exit 1
  else
    keydir = ENV['KEY_DIR']
  end

  if (ENV['name'] == nil) 
    raise "Specify username with 'name=\"username\"'"
    exit 1
  else
    usercn = ENV['name'].gsub(/@/, '_')
  end
  
  if (ENV['gateway'] == nil)
    raise "Specify the vpn gateway with 'gateway=\"gateway\"'"
    exit 1
  else
    gateway = ENV['gateway']
  end

    conf = <<EOF
client
dev tun
proto udp
remote #{gateway} 1194
resolv-retry infinite
nobind
persist-key
persist-tun
ca ca.crt
cert #{usercn}.crt
key #{usercn}.key
comp-lzo
verb 3
EOF

  puts "* Generate certificate for #{usercn}."
  sh %{./pkitool '#{usercn}'}

  puts "* Generate configuration files for #{usercn}"
  ["ovpn", "conf"].each do |config|
    File.open("#{keydir}/#{usercn}.#{config}", "w") do |file|
      file.puts conf
    end
  end

  puts "* Create .zip archive for #{usercn}."
  sh %{(cd #{keydir} && zip #{usercn}.zip ca.crt #{usercn}.crt #{usercn}.key #{usercn}.conf #{usercn}.ovpn)}
  sh %{chmod 0600 #{keydir}/#{usercn}.zip}
  zip_path = "/tmp"
  sh %{cp #{keydir}/#{usercn}.zip #{zip_path}/}
  sh %{rm #{keydir}/#{usercn}.*}
  puts "* Done, #{usercn} keys are in #{zip_path}/#{usercn}.zip"
end