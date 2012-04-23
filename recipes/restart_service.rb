#
# Cookbook Name:: cassandra
# Recipe:: restart_service
#
# Copyright 2011, DataStax
#
# Apache License
#

###################################################
# 
# Write Configs and Start Services
# 
###################################################

execute "set-java" do
  command 'echo "export JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk" | sudo -E tee -a /etc/environment'
  action :run
end

# Restart the service
service "cassandra" do
    supports :restart => true
    #notifies :run, resources(:execute => "set-java-home"), :immediately
    action :restart
end

