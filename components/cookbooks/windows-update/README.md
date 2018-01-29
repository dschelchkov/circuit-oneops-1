# Windows-update Cookbook

Facilitates configuring WSUS settings on VMs to receive Windows updates.
This cookbook has been forked from a community cookbook ([original_repository]) written by [original_author] and modified
accordingly to work inside Oneops infrastructure.

## Modifications to the original cookbook
 * Modified to support Chef 11.18.12
 * Test suites are removed
 * Attributes are being set up in recipes, coming from a WorkOrder
 * Added "detect" action when performing Windows Updates

## Testing

(TO-DO create unit tests to work with Oneops)

## Logs

The Microsoft.Update.Session object keeps a log in: C:\Windows\WindowsUpdate.log

## Usage

### WSUS settings

This cookbook has a dual nature, it works as a cloud service and a component.
When a cloud service "windows-update" is configured on a cloud, then during OS component deployment
on a Windows platform, an extra recipe will run to configure VM's WSUS settings using the settings from the cloud service (only if a windows-update component does not exist in the platform).

If a platform requires WSUS settings to be set up differently from the default settings specified in the cloud service, then a windows-update component can be added to the platform.
When a deployment for windows-update component is run it will configure VM's WSUS settings using the settings specified in the component, i.e. component settings have a priority over cloud service settings.

#### Attributes
The following attributes are used in the cloud service/oneops component:

Attribute                    | Description                                                                                            | Type                | Default
-----------------------------|--------------------------------------------------------------------------------------------------------|---------------------|--------
wsus_server                  |Defines a custom WSUS server to use instead of Microsoft Windows Update server                          |String, URI          |`nil`
update_group                 |Defines the current computer update group. (see [client-side targeting][client_targeting])              |String               |`nil`
disable_windows_update_access|Disables access to Windows Update (or your WSUS server)                                                 |TrueClass, FalseClass|`false`
enable_non_microsoft_updates |Allows signed non-Microsoft updates.                                                                    |TrueClass, FalseClass|`true`
allow_user_to_install_updates|Authorizes Users to approve or disapprove updates.                                                      |TrueClass, FalseClass|`false`
auto_install_minor_updates   |Defines whether minor update should be automatically installed.                                         |TrueClass, FalseClass|`false`
no_reboot_with_logged_users  |Disables automatic reboot with logged-on users.                                                         |TrueClass, FalseClass|`true`
automatic_update_behavior    |Defines auto update behavior.                                                                           |Symbol`*`            |`:disabled`
detection_frequency          |Defines times in hours between detection cycles.                                                        |FixNum               |`22`
schedule_install_day         |Defines the day of the week to schedule update install.                                                 |Symbol`**`           |`:every_day`
schedule_install_time        |Defines the time of day in 24-hour format to schedule update install.                                   |FixNum (1-23)        |`0`
schedule_retry_wait          |Defines the time in minutes to wait at startup before applying update from a missed scheduled time      |FixNum (0-60)        |`0`
reboot_warning               |Defines time in minutes of the restart warning countdown after reboot-required updates automatic install|FixNum (1-30)        |`5`
reboot_prompt_timeout        |Defines time in minutes between prompts for a scheduled restart                                         |FixNum (1-1440)      |`10`

`*` automatic_update_behavior values are:

```ruby
# :disabled  = Disables automatic updates
# :detect    = Only notify users of new updates
# :download  = Download updates, but let users install them
# :install   = Download and install updates
# :manual    = Lets the users configure the behavior
```

`**` schedule_install_day possible values are: `:every_day`, `:sunday`, `:monday`, `:tuesday`, `:wednesday`, `:thursday`, `:friday`, `:saturday`


### Manual Action

Also a "Windows-update" action has been added to the OS component. That action provides a way for a Oneops user to manually trigger downloading and/or installing windows patches on a particular compute.

#### Attributes
Attribute        | Description                                            | Type                  | Default     | Accepted values 
-----------------|--------------------------------------------------------|-----------------------|-------------|--------------------------
actions          | An array of actions to perform (see. actions above)    | Symbol array          | `[:detect]` | detect, download, install
download_timeout | Time alloted to the download operation before failing  | Integer               | `3600`      | n/a
install_timeout  | Time alloted to the install operation before failing   | Integer               | `3600`      | n/a
handle_reboot    | Indicate whether to reboot or not after update install | TrueClass, FalseClass | `false`     | true, false
reboot_delay     | The amount of time (in minutes) to delay the reboot    | Integer               | `1`         | 1-1440

> NOTE: `download_timeout` and `install_timeout` are currently hard-coded at 3600 seconds

##### Actions
Action   | Description
---------|------------------------------
detect   | Prints out available updates
download | Download available updates
install  | Install downloaded updates

# Links
 * [client_targeting]
 * [wsus_registry]
 * [auto_updates]
 * [API_documentation]
 * [original_repository]
 * [original_author]

# License

```text
Copyright 2018, WalmartLabs.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[original_author]:          https://github.com/Annih
[original_repository]:      https://github.com/criteo-cookbooks/wsus-client
[client_targeting]:         https://technet.microsoft.com/library/cc720450
[wsus_registry]:            https://technet.microsoft.com/library/dd939844
[auto_updates]:             http://smallvoid.com/article/winnt-automatic-updates-config.html
[API_documentation]:        http://msdn.microsoft.com/aa387099