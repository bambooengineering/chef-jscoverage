#
# Cookbook Name:: jscoverage
# Recipe:: default
#
# Copyright 2012, First Banco
#
# All rights reserved - Do Not Redistribute
#

cache_dir = Chef::Config[:file_cache_path]
tarball_file_name = node['jscoverage']['tar_ball_filename']
tar_path = "#{cache_dir}/#{tarball_file_name}"
source_url = node['jscoverage']['download_url']
unzip_path = "/tmp/jscoverage-#{node['jscoverage']['version']}"

package "zip" do
  action :install
end

remote_file "#{tar_path}" do
  source "#{source_url}"
  mode "0644"
  action :create_if_missing
end

execute "Extract #{tar_path}" do
  command <<-COMMAND
    tar xvfj #{tar_path} -C /tmp
  COMMAND
  creates "#{unzip_path}"
end

execute "Make and install" do
  path ["/bin", "/usr/bin", "/usr/local/bin", "#{unzip_path}"]
  cwd "#{unzip_path}"
  creates "/usr/local/bin/jscoverage"
  command "./configure && make && make install"
end
