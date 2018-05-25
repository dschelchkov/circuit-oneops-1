Description
===========

Configured a netscaler with lbvserver/pool and vserver/vservice

Changes
=======

Requirements
============

Attributes
==========

* `node['netscaler']['endpoint']` - the rest endpoint ex https://10.242.4.52/nitro/v1/config

License and Author
==================

Author:: Mike Schwankl

Copyright:: 2013 OneOps - Walmart Labs

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

# Configuring custom attributes for netscaler monitor
Example: we have this listener: `tcp 5432 tcp 5432`
(external protocol - external port - internal protocol - internal port)

Monitors are mapped to listeners by using internal port.
To configure monitors we use `ecv_map` attribute of the lb component, which is a hash.
Name part of the hash is internal port, value part is the request.
So the basic tcp monitor for the above mentioned listener would be:
`5432` => `get /foo/bar`

To configure custom monitor settings we can use the following format:
`port|attribute_name` => `attribute_value`.
For example, to configure an http monitor for the above mentioned listener we should add these entries:
* `5432|type` => `HTTP`
* `5432|httprequest` => `GET /foo/bar`
