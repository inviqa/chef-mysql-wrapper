#
# Cookbook Name:: chef-mysql-wrapper
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

mysql_service_name = 'default'

mysql_service mysql_service_name do
  port node['mysql']['port'].to_s
  version node['mysql']['version']
  initial_root_password node['mysql']['server_root_password']
  provider Chef::Provider::MysqlService::Sysvinit
  data_dir node['mysql']['data_dir']
  action [:create, :start]
end

log_dir = "#{node['platform_family'] == 'omnios' ? '/var/adm' : '/var'}/log/mysql-#{mysql_service_name}"

mysql_config 'legacy' do
  source 'legacy_my.cnf.erb'
  variables(
    :log_dir => log_dir
  )
  notifies :restart, "mysql_service[#{mysql_service_name}]"
end
