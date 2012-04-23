#
# Cookbook Name:: cassandra
# Recipe:: install
#
# Copyright 2011, DataStax
#
# Apache License
#

###################################################
# 
# Install Cassandra
# 
###################################################
#
#


execute "set-java" do
   command "update-alternatives --auto java" 
   action :nothing
end
# Used to clear any system information that may have
# been created when the service autostarts
execute "clear-data" do
  command "rm -rf /var/lib/cassandra/data/system"
  action :nothing
end

# Sets up a user to own the data directories
node[:internal][:package_user] = "cassandra"

# Installs the latest Cassandra 10x
#if node[:setup][:deployment] == "10x"
if node[:setup][:deployment] == "08x" or node[:setup][:deployment] == "07x" or  node[:setup][:deployment] == "10x" or  node[:setup][:deployment] == "11x"
  case node[:platform]
    when "ubuntu", "debian"
      package "cassandra" do
        #notifies :stop, resources(:service => "cassandra"), :immediately
        notifies :run, resources(:execute => "clear-data"), :immediately
        notifies :run, resources(:execute => "set-java"), :immediately
      end

    when "centos", "redhat", "fedora"
      package "cassandra08" do
        #notifies :stop, resources(:service => "cassandra10"), :immediately
        notifies :run, resources(:execute => "clear-data"), :immediately
      end
  end
end

service "cassandra" do 
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

# Drop the config.
template "/etc/cassandra/cassandra-env.sh" do
   owner "cassandra"
   group "cassandra"
   mode "0755"
   source "cassandra-env.sh.erb"
   notifies :restart , resources(:service => "cassandra")
end

template "/etc/cassandra/cassandra.yaml" do
   owner "cassandra"
   group "cassandra"
   mode "0644"
   source "cassandra.yaml.erb"
   notifies :restart , resources(:service => "cassandra")
end

template "/etc/cassandra/cassandra-topology.properties" do
	owner "cassandra"
	group "cassandra"
	mode "0644"
	source "cassandra-topology.properties.erb"
	# Pass the topology array as 't' to the template.
	#variables(
	#	:t => t
	#)
   notifies :restart , resources(:service => "cassandra")
end
