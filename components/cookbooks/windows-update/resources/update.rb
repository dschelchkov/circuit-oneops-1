actions :detect, :download, :install
default_action %i[download install]

attribute :download_timeout, :kind_of => Integer, :default => 3600
attribute :install_timeout, :kind_of => Integer, :default => 3600
attribute :handle_reboot, :kind_of => [TrueClass, FalseClass], :default => false
attribute :reboot_delay, :kind_of => Integer, :default => 1
