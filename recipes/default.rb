# Cookbook Name:: varnish
# Recipe:: default
# Author:: Joe Williams <joe@joetify.com>
# Contributor:: Patrick Connolly <patrick@myplanetdigital.com>
#
# Copyright 2008-2009, Joe Williams
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

include_recipe 'varnish::repo' if node['varnish']['use_default_repo']

package 'varnish'

template "#{node['varnish']['dir']}/#{node['varnish']['vcl_conf']}" do
  source node['varnish']['vcl_source']
  cookbook node['varnish']['vcl_cookbook']
  owner 'root'
  group 'root'
  mode 0644
  notifies :reload, 'service[varnish]', :delayed
  only_if { node['varnish']['vcl_generated'] == true }
end

template node['varnish']['default'] do
  source node['varnish']['conf_source']
  cookbook node['varnish']['conf_cookbook']
  owner 'root'
  group 'root'
  mode 0644
  notifies 'restart', 'service[varnish]', :delayed
end

service 'varnish' do
  supports restart: true, reload: true
  action %w(enable)
end

service 'varnishlog' do
  supports restart: true, reload: true
  action node['varnish']['log_daemon'] ? %w(enable start) : %w(disable stop)
end
