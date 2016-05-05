require 'spec_helper'

describe 'fmw_wls::install', :type => :class do


  describe 'unix' do 
    let :pre_condition do
      'class { "fmw_jdk::install":
         java_home_dir  => "/usr/java/jdk1.8.0_XX",
         source_file    => "/software/jdk-8u40-linux-x64.tar.gz",
       }'
    end

    describe 'When all attributes are default, on an unspecified platform' do

      it do
        expect { should contain_package('xxx')
               }.to raise_error(Puppet::Error, /Not supported Operation System, please use it on windows, linux or solaris host/)
      end
    end

    describe 'With attributes, on an unspecified platform' do
      let(:params){{
                    :java_home_dir       => '/usr/java/jdk1.8.0_XX',
                    :source_file         => '/software/fmw_12.1.3.0.0_wls.jar',
                  }}
      it do
        expect { should contain_package('xxx')
               }.to raise_error(Puppet::Error, /Not supported Operation System, please use it on windows, linux or solaris host/)
      end
    end

    describe 'With default attributes, on CentOS platform'  do
      let(:facts) {{ operatingsystem:           'CentOS',
                     kernel:                    'Linux',
                     osfamily:                  'RedHat',
                     operatingsystemmajrelease: '6' }}
      it do
        expect { should contain_package('xxx')
               }.to raise_error(Puppet::Error, /java_home_dir parameter cannot be empty/)
      end
    end

    describe 'With java_home_dir attribute, on CentOS platform'  do
      let(:facts) {{ operatingsystem:           'CentOS',
                     kernel:                    'Linux',
                     osfamily:                  'RedHat',
                     operatingsystemmajrelease: '6' }}
      let(:params){{
                    :java_home_dir       => '/usr/java/jdk1.8.0_XX'
                  }}
      it do
        expect { should contain_package('xxx')
               }.to raise_error(Puppet::Error, /source_file parameter cannot be empty/)
      end
    end

    describe 'With attributes 12.1.3, on CentOS platform' do
      let(:facts) {{ operatingsystem:           'CentOS',
                     kernel:                    'Linux',
                     osfamily:                  'RedHat',
                     operatingsystemmajrelease: '6' }}
      let(:params){{
                    :java_home_dir       => '/usr/java/jdk1.8.0_XX',
                    :source_file         => '/software/fmw_12.1.3.0.0_wls.jar',
                  }}
      it  { should contain_class('fmw_wls::internal::wls_linux').with(
                  java_home_dir:   '/usr/java/jdk1.8.0_XX',
                  source_file:     '/software/fmw_12.1.3.0.0_wls.jar',
                  install_type:    'wls',
                    )
      }
    end

    describe 'With attributes 12.1.3 infra, on CentOS platform' do
      let(:facts) {{ operatingsystem:           'CentOS',
                     kernel:                    'Linux',
                     osfamily:                  'RedHat',
                     operatingsystemmajrelease: '7' }}
      let(:params){{
                    :java_home_dir       => '/usr/java/jdk1.7.0_XX',
                    :source_file         => '/software/fmw_12.1.3.0.0_infrastructure.jar',
                    :install_type        => 'infra',
                  }}
      it  { should contain_class('fmw_wls::internal::wls_linux').with(
                  java_home_dir:   '/usr/java/jdk1.7.0_XX',
                  source_file:     '/software/fmw_12.1.3.0.0_infrastructure.jar',
                  install_type:    'infra',
                    )
      }
    end

    describe 'With attributes 12.1.3, on a Solaris platform' do
      let(:facts) {{ operatingsystem:           'Solaris',
                     kernel:                    'SunOS',
                     osfamily:                  'SunOS',
                     operatingsystemmajrelease: '5.11' }}
      let(:params){{
                    :java_home_dir       => '/usr/java/jdk1.8.0_XX',
                    :source_file         => '/software/fmw_12.1.3.0.0_wls.jar',
                  }}
      it  { should contain_class('fmw_wls::internal::wls_solaris').with(
                  java_home_dir:   '/usr/java/jdk1.8.0_XX',
                  source_file:     '/software/fmw_12.1.3.0.0_wls.jar',
                  install_type:    'wls',
                    )
      }
    end
  end

  describe 'With attributes 12.1.3, on Windows platform' do
    let :pre_condition do
      'class { "fmw_jdk::install":
         java_home_dir  => "C:/java/jdk1.7.0_XX",
         source_file    => "C://software/jdk-8u40-linux-x64.exe",
       }'
    end
    let(:facts) {{ operatingsystem:           'windows',
                   kernel:                    'windows',
                   osfamily:                  'windows'}}
    let(:params){{
                  :java_home_dir       => 'C:/java/jdk1.7.0_XX',
                  :source_file         => 'C:/software/fmw_12.1.3.0.0_wls.jar',
                }}
    it  { should contain_class('fmw_wls::internal::wls_windows').with(
                java_home_dir:   'C:/java/jdk1.7.0_XX',
                source_file:     'C:/software/fmw_12.1.3.0.0_wls.jar',
                install_type:    'wls',
                  )
    }
  end

end
