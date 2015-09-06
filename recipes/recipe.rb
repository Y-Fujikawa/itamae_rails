# # Yum Update
# execute "yum update" do
#   user "root"
#   command "yum -y update"
# end
#
# # Create User
# user "create user [#{node['user']['name']}]" do
#   username "#{node['user']['name']}"
#   password "#{node['user']['password']}"
# end
#
# directory "/home/#{node['user']['name']}/.ssh" do
#   owner "#{node['user']['name']}"
#   group "#{node['user']['name']}"
#   mode "700"
# end
#
# file "/home/#{node['user']['name']}/.ssh/authorized_keys" do
#   content "#{node['user']['ssh_key']}"
#   owner "#{node['user']['name']}"
#   group "#{node['user']['name']}"
#   mode "600"
# end
#
# template "/etc/sudoers" do
#   source "templates/sudoers"
#   mode "440"
#   owner "root"
#   group "root"
# end
#
# # rbenv install
# package "epel-release"
# package "gcc"
# package "libffi-devel"
# package "openssl-devel"
# package "libyaml-devel"
# package "readline-devel"
# package "zlib-devel"
# package "git"
#
# RBENV_DIR = "/usr/local/rbenv"
# RBENV_SCRIPT = "/etc/profile.d/rbenv.sh"
#
# git RBENV_DIR do
#   repository "git://github.com/sstephenson/rbenv.git"
# end
#
# remote_file RBENV_SCRIPT do
#   source "remote_files/rbenv.sh"
# end
#
# execute "set owner and mode for #{RBENV_SCRIPT} " do
#   command "chown root: #{RBENV_SCRIPT}; chmod 644 #{RBENV_SCRIPT}"
#   user "root"
# end
#
# execute "mkdir #{RBENV_DIR}/plugins" do
#   not_if "test -d #{RBENV_DIR}/plugins"
# end
#
# git "#{RBENV_DIR}/plugins/ruby-build" do
#   repository "git://github.com/sstephenson/ruby-build.git"
# end
#
# node["rbenv"]["versions"].each do |version|
#   execute "install ruby #{version}" do
#     command "source #{RBENV_SCRIPT}; rbenv install #{version}"
#     not_if "source #{RBENV_SCRIPT}; rbenv versions | grep #{version}"
#   end
# end
#
# execute "set global ruby #{node["rbenv"]["global"]}" do
#   command "source #{RBENV_SCRIPT}; rbenv global #{node["rbenv"]["global"]}; rbenv rehash"
#   not_if "source #{RBENV_SCRIPT}; rbenv global | grep #{node["rbenv"]["global"]}"
# end
#
# node["rbenv"]["gems"].each do |gem|
#   execute "gem install #{gem}" do
#     command "source #{RBENV_SCRIPT}; gem install #{gem}; rbenv rehash"
#     not_if "source #{RBENV_SCRIPT}; gem list | grep #{gem}"
#   end
# end
#
# # nginx install
# package "nginx"
#
# template "/etc/nginx/nginx.conf" do
#   source "templates/nginx.conf.erb"
# end
#
# service "nginx" do
#   action [:enable, :restart]
# end
#
# # change sshd_config
# SSHD_CONFIG_FILE = "/etc/ssh/sshd_config"
# execute "move sshd_config original" do
#   command "mv #{SSHD_CONFIG_FILE} #{SSHD_CONFIG_FILE}.org"
#   user "root"
# end
#
# template "#{SSHD_CONFIG_FILE}" do
#   source "templates/sshd_config.erb"
#   mode "600"
# end
#
# service "sshd" do
#   subscribes :restart, "template[#{SSHD_CONFIG_FILE}]"
# end
#
# # change iptables
# IPTABLES_FILE = "/etc/sysconfig/iptables"
# execute "move iptables original" do
#   command "mv #{IPTABLES_FILE} #{IPTABLES_FILE}.org"
#   user "root"
# end
#
# template "#{IPTABLES_FILE}" do
#   source "templates/iptables.erb"
#   mode "600"
# end
#
# service "iptables" do
#   subscribes :restart, "template[#{IPTABLES_FILE}]"
# end
#
# # Create init.d process unicorn
# template "/etc/init.d/unicorn" do
#   source "templates/unicorn.erb"
#   user "root"
#   owner "www"
#   group "www"
#   mode "0755"
# end
#
# execute "chkconfig unicorn" do
#   not_if "chkconfig --list | grep unicorn | grep 3:on"
#   command "chkconfig --add unicorn; chkconfig unicorn on"
# end
#
# # MySQL install
# execute "yum -y remove mysql*" do
#   not_if "rpm -q mysql-community-release-el6-5"
# end
#
# execute "delete MySQL" do
#   command "rm -rf /var/lib/mysql"
#   user "root"
#   not_if "rpm -q mysql-community-release-el6-5"
# end
#
# package "http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm" do
#   not_if "rpm -q mysql-community-release-el6-5"
# end
#
# %w[mysql-community-server mysql-community-devel].each do |pkg|
#   package pkg
# end
#
# execute "create mysql.sock" do
#   command "touch /var/lib/mysql/mysql.sock"
#   user "root"
#   not_if "test -e /var/lib/mysql/mysql.sock"
# end
#
# execute "chmod mysql.sock" do
#   command "chown mysql:mysql /var/lib/mysql/mysql.sock"
#   user "root"
#   not_if "test -e /var/lib/mysql/mysql.sock"
# end
#
# service "mysqld" do
#   action [:enable, :restart]
# end
#
# template "/etc/mysql_databases.sql" do
#   owner "root"
#   group "root"
#   mode "600"
#   notifies :run, "execute[create databases]", :immediately
# end
#
# require 'shellwords'
# execute "create databases" do
#   if node[:mysql][:server_root_password].empty?
#     password_string = ""
#   else
#     password_string = "-p" + Shellwords.escape(node[:mysql][:server_root_password])
#   end
#
#   cmd = "/bin/cat /etc/mysql_databases.sql | mysql"
#   cmd << " -u root #{password_string}"
#   command cmd
#   action :nothing
# end

# monit install
package "monit"

template "/etc/monit.conf" do
  source "templates/monit.conf.erb"
  owner "root"
  group "root"
  mode "700"
end

template "/etc/monit.d/nginx.conf" do
  source "templates/monit/nginx.conf.erb"
end

service "monit" do
  action [:enable, :restart]
end
