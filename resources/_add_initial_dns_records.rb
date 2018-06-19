property :instances, Array, required: true
property :dns_domain, String, required: true
property :dns_ipaddress, String, required: true 
property :reverse_dns, String, required: true

action :create do
  instances.each do |instance|
    ipaddress    = instance[0]
    a_record     = instance[1]

    next if a_record.to_s.empty? || ipaddress.to_s.empty?

    template "/tmp/#{a_record}.sh" do
      source "nsupdate.sh.erb"
      mode "755"
      variables(dns_domain: dns_domain,
                a_record:   a_record,
                ipaddress:  ipaddress,
                reverse_dns: reverse_dns,
                reverse_ip: ipaddress.split('.').reverse.join('.')
               )
      not_if do
        num_of_a_records = `nslookup #{a_record}.#{dns_domain} #{dns_ipaddress} | grep 'Name:' | wc -l`.strip
        is_current_record = `nslookup #{a_record}.#{dns_domain} #{dns_ipaddress} | grep '#{ipaddress}' | wc -l`.strip
        num_of_a_reverse_records = `nslookup #{ipaddress} #{dns_ipaddress} | grep 'Name:' | wc -l`.strip
        is_current__reverse_record = `nslookup #{ipaddress} #{dns_ipaddress} | grep '#{a_record}.#{dns_domain}' | wc -l`.strip
        if (num_of_a_records == "1" && is_current_record.to_i >= 1 && num_of_a_reverse_records == "1" && is_current_reverse_record.to_i >= 1)
          true
        else
          false
        end
      end
    end

    execute "running nsupdate #{a_record}" do
      command "nsupdate -v /tmp/#{a_record}.sh"
      notifies :delete, "file[/tmp/#{a_record}.sh]", :immediately
      not_if do
        num_of_a_records = `nslookup #{a_record}.#{dns_domain} #{dns_ipaddress} | grep 'Name:' | wc -l`.strip
        is_current_record = `nslookup #{a_record}.#{dns_domain} #{dns_ipaddress} | grep '#{ipaddress}' | wc -l`.strip
        num_of_a_reverse_records = `nslookup #{ipaddress} #{dns_ipaddress} | grep 'Name:' | wc -l`.strip
        is_current__reverse_record = `nslookup #{ipaddress} #{dns_ipaddress} | grep '#{a_record}.#{dns_domain}' | wc -l`.strip
        if (num_of_a_records == "1" && is_current_record.to_i >= 1 && num_of_a_reverse_records == "1" && is_current_reverse_record.to_i >= 1)
          true
        else
          false
        end
      end
    end

    file "/tmp/#{a_record}.sh" do
      action :nothing
    end
  end

end
