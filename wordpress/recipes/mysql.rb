#
# Cookbook Name:: wordpress
# Recipe:: mysql
#
# # Maintainer Satish Balakrishnan <satish@healthseq.com>
#
# All rights reserved - Do Not Redistribute
#




package 'python-pymysql' do
  action :install
  action :upgrade
end

package 'python-mysqldb' do
  action :install
  action :upgrade
end

cookbook_file 'mysql-seed' do
  source 'mysql-seed'
  owner 'root'
  group 'root'
  mode '0644'
end

package "mysql-server" do
  action :install
  response_file 'mysql-seed'
end

template '/etc/mysql/conf.d/mysqld_new.cnf' do
  source 'mysqld_new.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/tmp/createdb.sh' do
  source 'createdb.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

bash 'Create-all-database' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
    sh createdb.sh
  EOH
end

service "mysql" do
  supports :status => true, :restart => true, :stop => true, :start => true
  action [:restart]
end