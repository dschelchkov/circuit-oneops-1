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
# Recipe:: delete
#

return unless platform?('windows')
Chef::Log.debug('Running delete recipe for windows-update component')

#when deleting check if windows-update service exists, and re-configure wsus using settings from the service
if node['workorder']['services'].has_key?('windows-update')
  cloud = node['workorder']['cloud']['ciName']
  node.default['wsus_client'] = node['workorder']['services']['windows-update'][cloud]['ciAttributes']
  include_recipe 'windows-update::configure'
end
