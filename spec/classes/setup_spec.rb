require 'spec_helper'
describe 'fmw_wls::setup' , :type => :class do

  describe 'When all attributes are default, on an unspecified platform' do

    it do
      expect { should contain_package('xxx')
             }.to raise_error(Puppet::Error, /Unrecognized operating system, use this class on a Linux or Solaris host/)
    end
  end

  describe 'When all attributes are default, on CentOS platform' do
    let(:facts) {{ operatingsystem:           'CentOS',
                   kernel:                    'Linux',
                   osfamily:                  'RedHat',
                   operatingsystemmajrelease: '7' }}
    it  { should contain_group('oinstall') }
    it  { should contain_user('oracle').with(
                uid:    500,
                gid:    'oinstall',
                groups: 'oinstall',
                shell:  '/bin/bash',
                home:   '/home/oracle',
                ).that_requires('Group[oinstall]')
    }

  end

  describe 'When all attributes are default, on a Solaris platform' do
    let(:facts) {{ operatingsystem:           'Solaris',
                   kernel:                    'SunOS',
                   osfamily:                  'SunOS',
                   operatingsystemmajrelease: '5.11' }}
    it  { should contain_group('oinstall') }
    it  { should contain_user('oracle').with(
                uid:    500,
                gid:    'oinstall',
                groups: 'oinstall',
                shell:  '/bin/bash',
                home:   '/export/home/oracle',
                ).that_requires('Group[oinstall]')
    }
  end

end

