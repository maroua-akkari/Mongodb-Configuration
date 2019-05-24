#
# Cookbook:: mongodb
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

apt_update 'update' do
  action :update
end

apt_repository 'mongodb-org' do
  uri "http://repo.mongodb.org/apt/ubuntu"
  distribution "xenial/mongodb-org/3.2"
  components ["multiverse"]
  keyserver "hkp://keyserver.ubuntu.com:80"
  key "EA312927"
end

package 'mongodb-org' do
  action :upgrade
end

template '/lib/systemd/system/mongod.service' do
  source 'proxy.conf.erb'
  variables proxy_port: node['mongodb-org']['proxy_port']
  notifies :restart, 'service[mongodb-org]'
end

template '/etc/mongodb-org/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  variables proxy_port: node['mongodb-org']['proxy_port']
  notifies :restart, 'service[mongodb-org]'
end

link '/etc/mongodb-org/sites-enabled/proxy.conf' do
  to '/etc/mongodb-org/sites-available/proxy.conf'
  notifies :restart, 'service[mongodb-org]'
end

link '/etc/mongodb-org/sites-enabled/default' do
  notifies :restart, 'service[mongodb-org]'
  action :delete
end
