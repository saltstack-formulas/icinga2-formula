# frozen_string_literal: true

control 'icinga2 `features-available/ido-pgsql.conf` configuration' do
  title 'should match desired lines'

  describe file('/etc/icinga2/features-available/ido-pgsql.conf') do
    it { should be_file }
    it { should be_owned_by 'nagios' }
    it { should be_grouped_into 'nagios' }
    its('mode') { should cmp '0600' }
    its('content') { should include 'password = "SomeSecurePassword"' }
  end
end

control 'icinga2 `conf.d/hosts/example.com.conf` configuration' do
  title 'should match desired lines'

  describe file('/etc/icinga2/conf.d/hosts/example.com.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include 'object Host "example.com"' }
    its('content') { should include 'import "generic-host"' }
    its('content') { should include 'address = "1.2.3.4"' }
    its('content') { should include 'vars.sla = "24x7"' }
  end
end

control 'icinga2 `conf.d/hosts/example.com/http.conf` configuration' do
  title 'should match desired lines'

  describe file('/etc/icinga2/conf.d/hosts/example.com/http.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include 'object Service "http"' }
    its('content') { should include 'import "generic-service"' }
    its('content') { should include 'host_name = "example.com"' }
    its('content') { should include 'check_command = "http"' }
    its('content') { should include 'vars.sla = "24x7"' }
  end
end

control 'icinga2 `conf.d/hosts/example.com/ssh.conf` configuration' do
  title 'should match desired lines'

  describe file('/etc/icinga2/conf.d/hosts/example.com/ssh.conf') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include 'object Service "ssh"' }
    its('content') { should include 'import "generic-service"' }
    its('content') { should include 'host_name = "example.com"' }
    its('content') { should include 'check_command = "ssh"' }
    its('content') { should include 'vars.sla = "24x7"' }
  end
end

control 'icinga2 `conf.d/hosts/example.com/ssh_alt.conf` configuration' do
  title 'should match desired lines'

  describe file('/etc/icinga2/conf.d/hosts/example.com/ssh_alt.conf') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include 'object Service "ssh_alt"' }
    its('content') { should include 'import "generic-service"' }
    its('content') { should include 'host_name = "example.com"' }
    its('content') { should include 'check_command = "ssh"' }
    its('content') { should include 'vars.ssh_port = "43"' }
    its('content') { should include 'vars.sla = "24x7"' }
  end
end

control 'icinga2 `conf.d/hosts/example2.test.conf` configuration' do
  title 'should match desired lines'

  describe file('/etc/icinga2/conf.d/hosts/example2.test.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include 'object Host "example2.test"' }
    its('content') { should include 'import "generic-host"' }
    its('content') { should include 'address = "example2.test"' }
  end
end

control 'icinga2 `conf.d/templates/special-host.conf` configuration' do
  title 'should match desired lines'

  describe file('/etc/icinga2/conf.d/templates/special-host.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include 'template Host "special-host"' }
    its('content') { should include 'vars.sla = "24x5"' }
  end
end

control 'icinga2 `conf.d/templates/special-downtime.conf` configuration' do
  title 'should match desired lines'

  describe file('/etc/icinga2/conf.d/templates/special-downtime.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include 'template ScheduledDowntime "special-downtime"' }
    its('content') { should include 'ranges =' }
    its('content') { should include 'monday = "02:00-03:00"' }
  end
end

control 'icinga2 `conf.d/templates/special-notification.conf` configuration' do
  title 'should match desired lines'

  describe file('/etc/icinga2/conf.d/templates/special-notification.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include 'template Notification "special-notification"' }
    its('content') { should include 'types = [ FlappingStart,FlappingEnd ]' }
  end
end

control 'icinga2 `conf.d/users.conf` configuration' do
  title 'should not exist'

  describe file('/etc/icinga2/conf.d/users.conf') do
    it { should_not exist }
  end
end

control 'icinga2 `conf.d/users/alice.conf` configuration' do
  title 'should match desired lines'

  describe file('/etc/icinga2/conf.d/users/alice.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include 'object User "alice"' }
    its('content') { should include 'email = "alice@example.test"' }
    its('content') { should include 'groups = [ "icingaadmins" ]' }
    its('content') { should include 'vars.jabber = "alice@jabber.example.test"' }
  end
end

control 'icinga2 `conf.d/user_groups/icingaadmins_alt.conf` configuration' do
  title 'should match desired lines'

  describe file('/etc/icinga2/conf.d/user_groups/icingaadmins_alt.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include 'object UserGroup "icingaadmins_alt"' }
    its('content') { should include 'display_name = "Icinga 2 Admin Group (alt)"' }
  end
end

control 'icinga2 directories configuration' do
  title 'should match desired settings'

  %w[
    /etc/icinga2/conf.d/downtimes
    /etc/icinga2/conf.d/services
    /etc/icinga2/conf.d/check_command
    /etc/icinga2/scripts
  ].each do |d|
    describe file(d) do
      it { should be_directory }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its('mode') { should cmp '0755' }
    end
  end
end

control 'icingaweb2 directory configuration' do
  title 'should match desired settings'

  describe file('/etc/icingaweb2') do
    it { should be_directory }
    it { should be_owned_by 'www-data' }
    it { should be_grouped_into 'icingaweb2' }
    its('mode') { should cmp '0750' }
  end
end
