# frozen_string_literal: true

control 'icinga2 service' do
  impact 0.5
  title 'should be installed, running and enabled'

  describe service('icinga2') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
