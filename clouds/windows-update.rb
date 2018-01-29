name "windows-update"
description "Manage Windows Update"
auth "windowsupdatesecretkey"

service "windows-update-public",
  :cookbook => 'windows-update',
  :source => [Chef::Config[:register], Chef::Config[:version].split(".").first].join('.'),
  :provides => { :service => 'windows-update' },
  :attributes => {
    'wsus_server'                   => nil,
    'update_group'                  => nil,
    'disable_windows_update_access' => false,
    'enable_non_microsoft_updates'  => true,
    'allow_user_to_install_updates' => false,
    'auto_install_minor_updates'    => false,
    'no_reboot_with_logged_users'   => true,
    'automatic_update_behavior'     => :disabled,
    'detection_frequency'           => 22,
    'schedule_install_day'          => :every_day,
    'schedule_install_time'         => 0,
    'schedule_retry_wait'           => 0,
    'reboot_warning'                => 5,
    'reboot_prompt_timeout'         => 10
  }
