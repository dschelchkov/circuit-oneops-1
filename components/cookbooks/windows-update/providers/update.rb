def whyrun_supported?
  true
end

def verify!(result)
  return if result.HResult.zero? && result.ResultCode == ::WsusClient::Job::ResultCode::SUCCEEDED
  raise "Operation failed. (Error code #{result.HResult} - Result code #{result.ResultCode})"
end

def updates
  node.run_state['wsus_client_updates'] ||= [].tap do |updates|
    # Searches non installed updates
    search_result = session.CreateUpdateSearcher.Search 'IsInstalled=0'
    # Transforms to ruby array for future use
    search_result.Updates.each { |update| updates << update }
  end
end

def session
  require 'win32ole' if RUBY_PLATFORM =~ /mswin|mingw32|windows/
  # API documentation: http://msdn.microsoft.com/aa387099
  @session ||= ::WIN32OLE.new('Microsoft.Update.Session')
end


action :detect do
  #puts "ole_get_methods: #{updates.first.ole_get_methods}"
  updates_list = updates.map { |u| {'Title' => u.Title, 'IsDownloaded' => u.IsDownloaded, 'RebootRequired' => u.RebootRequired} }
  updates_list.each {|u| ::Chef::Log.info(u) }
end

action :download do
  updates_to_download = updates.reject(&:IsDownloaded)

  ::Chef::Log.info "Windows Auto Update: #{updates_to_download.size} update(s) to download."
  next if updates_to_download.empty?
  converge_by "downloading #{updates_to_download.count} update(s)" do
    # Performs download
    result = ::WsusClient::DownloadJob.new(session).run(updates_to_download, new_resource.download_timeout) do |update, progress|
      ::Chef::Log.info "Update '#{update.Title}' downloaded (#{progress}% done)"
    end
    # Verifies operation result
    verify! result
  end
end

action :install do
  downloaded_updates = updates.select(&:IsDownloaded)

  ::Chef::Log.info "Windows Auto Update: #{downloaded_updates.size} update(s) to install."
  next if downloaded_updates.empty?
  converge_by "installing #{downloaded_updates.count} update(s)" do
    # Accepts EULA when required
    downloaded_updates.reject(&:EulaAccepted).each do |update|
      converge_by("accepting EULA for #{update.Title}") { update.AcceptEula }
    end

    # Performs install
    result = ::WsusClient::InstallJob.new(session).run(downloaded_updates, new_resource.install_timeout) do |update, progress|
      ::Chef::Log.info "Update '#{update.Title}' installed (#{progress}% done)"
    end

    # Reboot if allowed and needed
    reboot 'Reboot for Windows updates' do
      action :reboot_now
      delay_mins new_resource.reboot_delay
      reason 'Reboot by chef for Windows updates'
      only_if { new_resource.handle_reboot && result.RebootRequired }
    end

    # Verifies operation result
    verify! result
  end
end
