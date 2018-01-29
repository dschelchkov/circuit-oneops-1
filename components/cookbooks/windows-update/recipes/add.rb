# Copyright 2018, WalmartLabs
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
# Cookbook Name:: windows-update
# Recipe:: add
#

return unless platform?('windows')
Chef::Log.debug('Running add recipe for windows-update component')

#if the platform has windows-update component do not configure WSUS settings now. 
#let windows-update component do that

rfcCi = node['workorder']['rfcCi']
component = rfcCi['ciClassName'].split('.').last
settings_ci = nil
if component == 'Os' && !node['workorder']['payLoad'].has_key?('windows-update-component') && node['workorder']['services'].has_key?('windows-update')
  cloud = node['workorder']['cloud']['ciName']
  settings_ci = node['workorder']['services']['windows-update'][cloud]['ciAttributes']
elsif component == 'Windows-update'
  settings_ci = rfcCi['ciAttributes']
end

if !settings_ci.nil?
  node.default['wsus_client'] = settings_ci
  include_recipe 'windows-update::configure'
end