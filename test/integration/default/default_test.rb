describe user('bind') do
  it { should exist }
end

describe port(53)  do
  it { should be_listening }
end

describe systemd_service('bind9') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe file('/var/cache/bind/db.gojek.com') do
  it { should exist }
end


describe file('/var/cache/bind/db.192') do
  it { should exist }
end
