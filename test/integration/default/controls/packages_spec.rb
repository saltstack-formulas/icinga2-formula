# frozen_string_literal: true

control 'icinga2 packages' do
  title 'should be installed'

  %w[
    icinga2-ido-pgsql
    icinga2
    icingaweb2
    icingaweb2-module-doc
    icingaweb2-module-monitoring
  ].each do |p|
    describe package(p) do
      it { should be_installed }
    end
  end
end
