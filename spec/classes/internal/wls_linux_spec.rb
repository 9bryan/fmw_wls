require 'spec_helper'
describe 'fmw_wls::internal::wls_linux' do

  describe 'With attributes 12.1.3, on CentOS platform' do
    let :pre_condition do
      'class { "fmw_jdk::install":
         java_home_dir  => "/usr/java/jdk1.8.0_XX",
         source_file    => "/software/jdk-8u40-linux-x64.tar.gz",
       } 
       class { "fmw_wls":}
       '
    end

    let(:facts) {{ operatingsystem:           'CentOS',
                   kernel:                    'Linux',
                   osfamily:                  'RedHat',
                   operatingsystemmajrelease: '6' }}
    let(:params){{
                  :java_home_dir       => '/usr/java/jdk1.8.0_XX',
                  :source_file         => '/software/fmw_12.1.3.0.0_wls.jar',
                  :install_type        => 'wls',
                }}

    it  { should contain_file('/etc/oraInst.loc').with(
                ensure:    'present',
                content:   "inventory_loc=/home/oracle/oraInventory\ninst_group=oinstall",
                mode:      '0755',
                owner:     'root',
                group:     'root'
                )
    }
    it  { should contain_file('/home/oracle/oraInventory').with(
                ensure:    'directory',
                mode:      '0775',
                owner:     'oracle',
                group:     'oinstall'
                )
    }
    it  { should contain_file('/opt/oracle').with(
                ensure:    'directory',
                mode:      '0775',
                owner:     'oracle',
                group:     'oinstall'
                )
    }
    it  { should contain_file('/opt/oracle/middleware').with(
                ensure:    'directory',
                mode:      '0775',
                owner:     'oracle',
                group:     'oinstall'
                ).that_requires('File[/opt/oracle]')
    }
    it  { should contain_file('/tmp/wls_12c.rsp').with(
                ensure:    'present',
                content:   "[ENGINE]\nResponse File Version=1.0.0.0.0\n[GENERIC]\n\n#The oracle home location. This can be an existing Oracle Home or a new Oracle Home\nORACLE_HOME=/opt/oracle/middleware\n#Set this variable value to the Installation Type selected. e.g. WebLogic Server, Coherence, Complete with Examples.\nINSTALL_TYPE=WebLogic Server\n\n#Provide the My Oracle Support Username. If you wish to ignore Oracle Configuration Manager configuration provide empty string for user name.\nMYORACLESUPPORT_USERNAME=\n#Provide the My Oracle Support Password\nMYORACLESUPPORT_PASSWORD=<SECURE VALUE>\n#Set this to true if you wish to decline the security updates. Setting this to true and providing empty string for My Oracle Support username will ignore the Oracle Configuration Manager configuration\nDECLINE_SECURITY_UPDATES=true\n#Set this to true if My Oracle Support Password is specified\nSECURITY_UPDATES_VIA_MYORACLESUPPORT=false\n",
                mode:      '0755',
                owner:     'oracle',
                group:     'oinstall'
                )
    }

    it  { should contain_exec('Install WLS').with(
                command:   "/usr/java/jdk1.8.0_XX/bin/java -Xmx1024m -Djava.io.tmpdir=/tmp -jar /software/fmw_12.1.3.0.0_wls.jar -silent -responseFile /tmp/wls_12c.rsp -invPtrLoc /etc/oraInst.loc",
                creates:   "/opt/oracle/middleware/oracle_common",
                user:      'oracle',
                group:     'oinstall',
                cwd:       '/tmp',
                ).that_requires('File[/tmp/wls_12c.rsp]').that_requires('File[/etc/oraInst.loc]').that_requires('File[/home/oracle/oraInventory]').that_requires('File[/opt/oracle]').that_requires('File[/opt/oracle/middleware]')
    }

  end

  describe 'With attributes 12.1.3 infra, on CentOS platform' do
    let :pre_condition do
      'class { "fmw_jdk::install":
         java_home_dir  => "/usr/java/jdk1.7.0_XX",
         source_file    => "/software/jdk-7u75-linux-x64.tar.gz",
       } 
       class { "fmw_wls":}
       '
    end
    let(:facts) {{ operatingsystem:           'CentOS',
                   kernel:                    'Linux',
                   osfamily:                  'RedHat',
                   operatingsystemmajrelease: '7' }}
    let(:params){{
                  :java_home_dir       => '/usr/java/jdk1.7.0_XX',
                  :source_file         => '/software/fmw_12.1.3.0.0_infrastructure.jar',
                  :install_type        => 'infra',
                }}

    it  { should contain_file('/etc/oraInst.loc').with(
                ensure:    'present',
                content:   "inventory_loc=/home/oracle/oraInventory\ninst_group=oinstall",
                mode:      '0755',
                owner:     'root',
                group:     'root'
                )
    }
    it  { should contain_file('/home/oracle/oraInventory').with(
                ensure:    'directory',
                mode:      '0775',
                owner:     'oracle',
                group:     'oinstall'
                )
    }
    it  { should contain_file('/opt/oracle').with(
                ensure:    'directory',
                mode:      '0775',
                owner:     'oracle',
                group:     'oinstall'
                )
    }
    it  { should contain_file('/opt/oracle/middleware').with(
                ensure:    'directory',
                mode:      '0775',
                owner:     'oracle',
                group:     'oinstall'
                ).that_requires('File[/opt/oracle]')
    }
    it  { should contain_file('/tmp/wls_12c.rsp').with(
                ensure:    'present',
                content:   "[ENGINE]\nResponse File Version=1.0.0.0.0\n[GENERIC]\n\n#The oracle home location. This can be an existing Oracle Home or a new Oracle Home\nORACLE_HOME=/opt/oracle/middleware\n#Set this variable value to the Installation Type selected. e.g. WebLogic Server, Coherence, Complete with Examples.\nINSTALL_TYPE=Fusion Middleware Infrastructure\n\n#Provide the My Oracle Support Username. If you wish to ignore Oracle Configuration Manager configuration provide empty string for user name.\nMYORACLESUPPORT_USERNAME=\n#Provide the My Oracle Support Password\nMYORACLESUPPORT_PASSWORD=<SECURE VALUE>\n#Set this to true if you wish to decline the security updates. Setting this to true and providing empty string for My Oracle Support username will ignore the Oracle Configuration Manager configuration\nDECLINE_SECURITY_UPDATES=true\n#Set this to true if My Oracle Support Password is specified\nSECURITY_UPDATES_VIA_MYORACLESUPPORT=false\n",
                mode:      '0755',
                owner:     'oracle',
                group:     'oinstall'
                )
    }

    it  { should contain_exec('Install WLS').with(
                command:   "/usr/java/jdk1.7.0_XX/bin/java -Xmx1024m -Djava.io.tmpdir=/tmp -jar /software/fmw_12.1.3.0.0_infrastructure.jar -silent -responseFile /tmp/wls_12c.rsp -invPtrLoc /etc/oraInst.loc",
                creates:   "/opt/oracle/middleware/oracle_common",
                user:      'oracle',
                group:     'oinstall',
                cwd:       '/tmp',
                ).that_requires('File[/tmp/wls_12c.rsp]').that_requires('File[/etc/oraInst.loc]').that_requires('File[/home/oracle/oraInventory]').that_requires('File[/opt/oracle]').that_requires('File[/opt/oracle/middleware]')
    }


  end

  describe 'With attributes 10.3.6,  on CentOS platform' do
    let :pre_condition do
      'class { "fmw_jdk::install":
         java_home_dir  => "/usr/java/jdk1.7.0_XX",
         source_file    => "/software/jdk-7u75-linux-x64.tar.gz",
       } 
       class { "fmw_wls":
         version             => "10.3.6",
         middleware_home_dir => "/opt/oracle/middleware_11g",
         os_user             => "wls",
       }
      '
    end
    let(:facts) {{ operatingsystem:           'CentOS',
                   kernel:                    'Linux',
                   osfamily:                  'RedHat',
                   operatingsystemmajrelease: '7' }}
    let(:params){{
                  :java_home_dir       => '/usr/java/jdk1.7.0_XX',
                  :source_file         => '/software/wls1036_generic.jar',
                  :install_type        => 'wls',
                }}

    it  { should contain_file('/etc/oraInst.loc').with(
                ensure:    'present',
                content:   "inventory_loc=/home/oracle/oraInventory\ninst_group=oinstall",
                mode:      '0755',
                owner:     'root',
                group:     'root'
                )
    }
    it  { should contain_file('/home/oracle/oraInventory').with(
                ensure:    'directory',
                mode:      '0775',
                owner:     'wls',
                group:     'oinstall'
                )
    }
    it  { should contain_file('/opt/oracle').with(
                ensure:    'directory',
                mode:      '0775',
                owner:     'wls',
                group:     'oinstall'
                )
    }
    it  { should contain_file('/opt/oracle/middleware_11g').with(
                ensure:    'directory',
                mode:      '0775',
                owner:     'wls',
                group:     'oinstall'
                ).that_requires('File[/opt/oracle]')
    }
    it  { should contain_file('/tmp/wls_11g.rsp').with(
                ensure:    'present',
                content:   "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<bea-installer>\n  <input-fields>\n    <data-value name=\"BEAHOME\" value=\"/opt/oracle/middleware_11g\" />\n  </input-fields>\n</bea-installer>\n",
                mode:      '0755',
                owner:     'wls',
                group:     'oinstall'
                )
    }

    it  { should contain_exec('Install WLS').with(
                command:   "/usr/java/jdk1.7.0_XX/bin/java -Xmx1024m -Djava.io.tmpdir=/tmp -Duser.country=US -Duser.language=en -jar /software/wls1036_generic.jar -mode=silent -silent_xml=/tmp/wls_11g.rsp -log=/tmp/wls.log -log_priority=info",
                creates:   "/opt/oracle/middleware_11g/modules",
                user:      'wls',
                group:     'oinstall',
                cwd:       '/tmp',
                ).that_requires('File[/tmp/wls_11g.rsp]').that_requires('File[/etc/oraInst.loc]').that_requires('File[/home/oracle/oraInventory]').that_requires('File[/opt/oracle]').that_requires('File[/opt/oracle/middleware_11g]')
    }


  end

end
