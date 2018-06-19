execute "apt-get update -y"
package "bind9"
dns_domain = node["dns"]["domain"]
reverse_dns = node["reverse"]["dns"]

template "/etc/bind/named.conf.options" do
  source "named.conf.options.erb"
  user "bind"
  variables(forwarder_1: "8.8.8.8", forwarder_2: "8.8.4.4" )
  notifies :restart, "service[bind9]", :delayed
end

template "/etc/bind/named.conf.local" do
  source "master_nameserver_named.conf.local.erb"
  user "bind"
  variables(dns_domain: dns_domain, reverse_dns: reverse_dns)
  notifies :restart, "service[bind9]", :delayed
end

template "/var/cache/bind/db.#{dns_domain}" do
  source "db.zone.erb"
  user "bind"
  variables(dns_domain: dns_domain)
  notifies :restart, "service[bind9]", :delayed
  end

template "/var/cache/bind/db.#{reverse_dns}" do
  source "db.zone.erb"
  user "bind"
  variables(dns_domain: dns_domain)
  notifies :restart, "service[bind9]", :delayed
end

service "bind9" do
  action :enable
  supports start: true, stop: true, restart: true, enable: true
end
