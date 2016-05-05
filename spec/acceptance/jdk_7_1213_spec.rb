require 'spec_helper_acceptance'

describe 'jdk_7_1213' do

  if os[:platform]  =~ /windows/

  else
    # Serverspec examples can be found at
    # http://serverspec.org/resource_types.html
    it 'Should apply the manifest without error' do
      pp = <<-EOS
        node default {

          if $::kernel == 'Linux' {
            unless ( $::osfamily == 'RedHat' and $::operatingsystemmajrelease == '5') {
              include fmw_jdk::rng_service
            }
          }

          $java_home_dir = '/usr/java/jdk1.7.0_75'

          Class['fmw_wls::setup'] ->
            Class['fmw_wls::install']

          class { 'fmw_jdk::install':
            java_home_dir => $java_home_dir,
            source_file   => '/software/jdk-7u75-linux-x64.tar.gz',
          }

          # can be removed when all the default are used.
          class { 'fmw_wls':
            version             => '12.1.3',  # this is also the default
            middleware_home_dir => '/opt/oracle/middleware_1213',
            os_user_uid         => '600',
          }

          include fmw_wls::setup

          # this requires fmw_jdk::install
          class { 'fmw_wls::install':
            java_home_dir => $java_home_dir,
            source_file   => '/software/fmw_12.1.3.0.0_wls.jar',
          }

        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true, :acceptable_exit_codes => [0, 2])
      apply_manifest(pp, :catch_failures => true, :acceptable_exit_codes => [0, 2])
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
      shell('sleep 15')
    end

    describe file('/usr/java/jdk1.7.0_75') do
      it { should be_directory }
      it { should be_owned_by 'root' }
    end

    describe file('/usr/java/jdk1.7.0_75/bin/java') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_executable }
    end

    describe file('/usr/bin/java') do
      it { should be_symlink }
      it { should be_linked_to '/etc/alternatives/java' }
    end

    describe group('oinstall') do
      it { should exist }
    end

    describe user('oracle') do
      it { should belong_to_group 'oinstall' }
      it { should have_home_directory '/home/oracle' }
      it { should have_login_shell '/bin/bash' }
    end

    describe file('/etc/oraInst.loc') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_readable.by('others') }
      it { should contain 'inventory_loc=/home/oracle/oraInventory' }
      it { should contain 'inst_group=oinstall' }
    end

    describe file('/tmp/wls_12c.rsp') do
      it { should be_file }
      it { should contain 'ORACLE_HOME=/opt/oracle/middleware_1213' }
      it { should contain 'INSTALL_TYPE=WebLogic Server' }
    end

    describe file('/home/oracle/oraInventory') do
      it { should be_directory }
      it { should be_owned_by 'oracle' }
      it { should be_grouped_into 'oinstall' }
    end

    describe file('/opt/oracle/middleware_1213') do
      it { should be_directory }
      it { should be_owned_by 'oracle' }
      it { should be_grouped_into 'oinstall' }
    end

    describe file('/opt/oracle/middleware_1213/oracle_common/common/bin/wlst.sh') do
      it { should be_file }
      it { should be_owned_by 'oracle' }
      it { should be_grouped_into 'oinstall' }
      it { should be_executable }
    end
  end

end
