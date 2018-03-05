#
# Cookbook:: openvpn
# Recipe:: install
#
# Copyright:: 2014-2018, Xhost Australia
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

if platform_family? 'debian'
  apt_repository 'openvpn' do
    uri          "http://build.openvpn.net/debian/openvpn/release/#{node['openvpn']['major_version']}"
    components   %w(main)
    distribution node['lsb']['codename']
    key          'https://swupdate.openvpn.net/repos/repo-public.gpg'
  end

  # Make sure the apt cache is up-to-date
  node.override['apt']['compile_time_update'] = true
  include_recipe 'apt'
end

include_recipe 'yum-epel' if platform_family?('rhel')

if node['openvpn']['git_package'] == true
  package 'openvpn-git'
else
  package 'openvpn'
end
