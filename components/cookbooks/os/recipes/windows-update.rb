#
# Cookbook Name:: os
# Recipe:: windows-update
#

return unless platform?('windows')
require 'json'

settings_ci = nil
if node['workorder']['payLoad'].has_key?('windows-update-component') 
  settings_ci = node['workorder']['payLoad']['windows-update-component'][0]['ciAttributes']
elsif node['workorder']['services'].has_key?('windows-update')
  cloud = node['workorder']['cloud']['ciName']
  settings_ci = node['workorder']['services']['windows-update'][cloud]['ciAttributes']
end

if !settings_ci.nil?
  node.default['wsus_client'] = settings_ci
end

args = JSON.parse(node['workorder']['arglist'])
args_hash = Hash[args.map {|k, v| [k, v]}]

#Action requires special handling - it has to be an array but we can only use string in arguments
action = args_hash['action']
if action == 'install'
  node.default['wsus_client']['update']['action'] = %i[download install]
elsif ['detect','download'].include?(action)
  node.default['wsus_client']['update']['action'] = [action.to_sym]
else
  exit_with_error("#{action} is not a valid action. Correct actions are: detect, download, install.")
end

node.default['wsus_client']['update']['handle_reboot'] = args_hash['handle_reboot'] == 'true' ? true : false
node.default['wsus_client']['update']['reboot_delay'] = args_hash['reboot_delay'].to_i

include_recipe 'windows-update::wsus-update'
