name             'Windows-update'
maintainer       'Oneops'
maintainer_email 'support@oneops.com'
license          'Apache License, Version 2.0'
description      'Configures Windows Update'
version          '0.1.0'

supports 'windows'

grouping 'default',
  :access => 'global',
  :packages => [ 'base', 'mgmt.cloud.service', 'cloud.service', 'service.windows-patching', 'mgmt.catalog', 'mgmt.manifest', 'catalog', 'manifest', 'bom'],
  :namespace => true


attribute 'wsus_server',
  :description => 'WSUS Server',
  :default     => nil,
  :format      => {
    :help      => 'URL of the WSUS server. Must use Https:// or Http://',
    :category  => '1.General',
    :order     => 1
  }

attribute 'update_group',
  :description => 'Update Grou[',
  :default     => nil,
  :format      => {
    :help      => 'Defines the current computer update group',
    :category  => '1.General',
    :order     => 2,
    :filter    => {'all' => {'visible' => 'false'}}
  }

attribute 'disable_windows_update_access',
          :description => 'Disables Windows Update access',
          :default     => 'false',
          :format      => {
            :help     => 'Disables access to Windows Update (or your WSUS server)',
            :category => '1.General',
            :form     => {'field' => 'checkbox'},
            :order    => 3
          }

attribute 'enable_non_microsoft_updates',
          :description => 'Enable non-Microsoft updates.',
          :default     => 'true',
          :format      => {
            :help     => 'Allows signed non-Microsoft updates.',
            :category => '1.General',
            :form     => {'field' => 'checkbox'},
            :order    => 4
          }

attribute 'allow_user_to_install_updates',
          :description => 'Allows user to install updates.',
          :default     => 'false',
          :format      => {
            :help     => 'Authorizes Users to approve or disapprove updates',
            :category => '1.General',
            :form     => {'field' => 'checkbox'},
            :order    => 5
          }

attribute 'auto_install_minor_updates',
          :description => 'Auto install minor updates',
          :default     => 'false',
          :format      => {
            :help     => 'Defines whether minor update should be automatically installed.',
            :category => '1.General',
            :form     => {'field' => 'checkbox'},
            :order    => 6
          }

attribute 'no_reboot_with_logged_users',
          :description => 'No reboot with logged users',
          :default     => 'true',
          :format      => {
            :help     => 'Disables automatic reboot with logged-on users.',
            :category => '1.General',
            :form     => {'field' => 'checkbox'},
            :order    => 7
          }

attribute 'automatic_update_behavior',
  :description => 'Automatic Update behavior',
  :default     => :disabled,
  :format      => {
    :help      => 'Configure the Automatic Update client options',
    :category  => '1.General',
    :order     => 8,
    :form      => { 'field' => 'select', 'options_for_select' => [
                                                                    ['Disables automatic updates', :disabled], 
                                                                    ['Only notify users of new updates', :detect], 
                                                                    ['Download updates, but let users install them', :download],
                                                                    ['Download and install updates', :install],
                                                                    ['Lets the users configure the behavior', :manual]
                                                                 ] }
  }

attribute 'detection_frequency',
  :description => 'Detection Frequency',
  :default     => 22,
  :format      => {
    :help      => 'Specifed time (in hours) for detection from client to server. Accepted range is: 0-22, 0 means detection disabled',
    :category  => '1.General',
    :order     => 9,
    :pattern   => '^(\d|1\d|2[0-2])$'
  }

attribute 'schedule_install_day',
  :description => 'Schedule Install Day',
  :default     => :every_day,
  :format      => {
    :help      => 'Specified Day of the week to perform automatic installation. Only valid when Options is set to "DownloadAndInstall"',
    :category  => '1.General',
    :order     => 10,
    :form      => { 'field' => 'select', 'options_for_select' => [
                                                                    ['Everyday', :every_day], 
                                                                    ['Monday', :monday], 
                                                                    ['Tuesday', :tuesday],
                                                                    ['Wednesday', :wednesday],
                                                                    ['Thursday', :thursday],
                                                                    ['Friday', :friday],
                                                                    ['Saturday', :saturday],
                                                                    ['Sunday', :sunday]
                                                                 ] }
  }

attribute 'schedule_install_time',
  :description => 'Schedule Install Time',
  :default     => 0,
  :format      => {
    :help      => 'Specified Hour of the day to perform automatic installation. Valid range is 0-23',
    :category  => '1.General',
    :order     => 11,
    :pattern   => '^(\d|1\d|2[0-3])$'
  }

attribute 'schedule_retry_wait',
  :description => 'Schedule retry wait',
  :default     => 0,
  :format      => {
    :help      => 'Defines the time in minutes to wait at startup before applying update from a missed scheduled time',
    :category  => '1.General',
    :order     => 12,
    :pattern   => '^\d+$'
  }

attribute 'reboot_warning',
  :description => 'Reboot Warning Timeout',
  :default     => 5,
  :format      => {
    :help      => 'Defines time in minutes of the restart warning countdown after reboot-required updates automatic install. Accepted range is: 1-30',
    :category  => '1.General',
    :order     => 13,
    :pattern   => '^(\d|[1-2]\d|30)$'
  }

attribute 'reboot_prompt_timeout',
  :description => 'Reboot Prompt Timeout',
  :default     => 10,
  :format      => {
    :help      => 'Defines time in minutes between prompts for a scheduled restart. Accepted range is: 1-1440',
    :category  => '1.General',
    :order     => 14,
    :pattern   => '^(\d{1,3}|1[0-3]\d{1,2}|14[0-3]\d|1440)$'
  }
