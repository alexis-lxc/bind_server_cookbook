primary_nameserver = node['primary_nameserver_ip']

default_interface = `route | grep default | awk '{print $NF}'| uniq | tr -d '\n'`

template "/etc/dhcp/dhclient.conf" do
  source "dhclient.conf.erb"
  variables(primary_nameserver:  primary_nameserver)
  user "root"
end

execute "stop dhclient" do
  command "sudo dhclient -pf /run/dhclient.#{default_interface}.pid -x"
  user "root"
end

execute "start dhclient with leases" do
  command "sudo dhclient -1 -v -pf /run/dhclient.#{default_interface}.pid -lf /var/lib/dhcp/dhclient.#{default_interface}.leases #{default_interface}"
  user "root"
end
