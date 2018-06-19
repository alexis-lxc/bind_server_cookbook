execute "apt-get update -y"
package "bind9"
reverse_dns = node["reverse"]["dns"]
dns_domain = node["dns"]["domain"]
master_nameserver_ip = node['master_nameserver_ip']
forwarder_1 = '8.8.4.4'
forwarder_2 = '8.8.8.8'

template "/etc/bind/named.conf.options" do
  source "named.conf.options.erb"
  user "bind"
  variables(forwarder_1: forwarder_1, forwarder_2: forwarder_2 )
  notifies :restart, "service[bind9]", :delayed
end

template "/etc/bind/named.conf.local" do
  source "secondary_nameserver_named.conf.local.erb"
  user "bind"
  variables(dns_domain: dns_domain, reverse_dns: reverse_dns,  master_nameserver_ip: master_nameserver_ip)
  notifies :restart, "service[bind9]", :delayed
end

service "bind9" do
  action :enable
  supports start: true, stop: true, restart: true, enable: true
end

include_recipe "dns_server::setup_dns_resolution"

cron 'sync_dns_zone' do
  minute '*/1'
  user 'root'
  command "/usr/sbin/rndc reload #{reverse_dns}.in-addr.arpa. && /usr/sbin/rndc reload #{dns_domain}"
end
