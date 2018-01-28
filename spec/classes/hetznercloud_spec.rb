require 'spec_helper'

describe 'hetznercloud' do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      context 'with all defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_package('hcloud') }
      end

      context 'with non-defaults installs the package' do
        let :params do
          {
            manage_hcloud: true
          }
        end

        it { is_expected.to contain_package('hcloud') }
      end
      context 'with non-default package name installs the package' do
        let :params do
          {
            manage_hcloud: true,
            hcloud_package_name: 'bla'
          }
        end

        it { is_expected.to contain_package('bla') }
      end
    end
  end
end
