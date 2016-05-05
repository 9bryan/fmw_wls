require 'spec_helper'
describe 'fmw_wls::internal::wls_windows' do

  describe 'With attributes 12.1.3, on Windows platform' do
    let :pre_condition do
      'class { "fmw_jdk::install":
         java_home_dir   => "c:\\java\\jdk1.7.0_75",
         source_file     => "c:\\software\\jdk-7u75-windows-x64.exe",
       } 
       class { "fmw_wls":}
       '
    end

    let(:facts) {{ operatingsystem:           'windows',
                   kernel:                    'windows',
                   osfamily:                  'windows'}}
    let(:params){{
                  :java_home_dir       => 'c:\\java\\jdk1.7.0_75',
                  :source_file         => 'c:\\software\\fmw_12.1.3.0.0_wls.jar',
                  :install_type        => 'wls',
                }}

    it  { should contain_registry__value('inst_loc').with(
                key:    'HKLM\SOFTWARE\Oracle',
                data:   'C:\\Program Files\\Oracle\\Inventory',
                )
    }

    it  { should contain_file('C:/temp/wls_12c.rsp').with(
                ensure:    'present',
                content:   "[ENGINE]\nResponse File Version=1.0.0.0.0\n[GENERIC]\n\n#The oracle home location. This can be an existing Oracle Home or a new Oracle Home\nORACLE_HOME=C:/oracle/middleware\n#Set this variable value to the Installation Type selected. e.g. WebLogic Server, Coherence, Complete with Examples.\nINSTALL_TYPE=WebLogic Server\n\n#Provide the My Oracle Support Username. If you wish to ignore Oracle Configuration Manager configuration provide empty string for user name.\nMYORACLESUPPORT_USERNAME=\n#Provide the My Oracle Support Password\nMYORACLESUPPORT_PASSWORD=<SECURE VALUE>\n#Set this to true if you wish to decline the security updates. Setting this to true and providing empty string for My Oracle Support username will ignore the Oracle Configuration Manager configuration\nDECLINE_SECURITY_UPDATES=true\n#Set this to true if My Oracle Support Password is specified\nSECURITY_UPDATES_VIA_MYORACLESUPPORT=false\n",
                )
    }

    it  { should contain_exec('Install WLS').with(
                command:   "c:\\java\\jdk1.7.0_75\\bin\\java.exe -Xmx1024m -Djava.io.tmpdir=C:/temp -jar c:\\software\\fmw_12.1.3.0.0_wls.jar -silent -responseFile C:/temp/wls_12c.rsp",
                creates:   "C:/oracle/middleware/oracle_common",
                ).that_requires('File[C:/temp/wls_12c.rsp]').that_requires('Registry::Value[inst_loc]')
    }

  end

  describe 'With attributes 12.1.3 infra, on Windows platform' do
    let :pre_condition do
      'class { "fmw_jdk::install":
         java_home_dir   => "c:\\java\\jdk1.7.0_75",
         source_file     => "c:\\software\\jdk-7u75-windows-x64.exe",
       } 
       class { "fmw_wls":}
       '
    end
    let(:facts) {{ operatingsystem:           'windows',
                   kernel:                    'windows',
                   osfamily:                  'windows'}}
    let(:params){{
                  :java_home_dir       => 'c:\\java\\jdk1.7.0_75',
                  :source_file         => 'c:\\software\\wls1036_generic.jar',
                  :install_type        => 'infra',
                }}

    it  { should contain_registry__value('inst_loc').with(
                key:    'HKLM\SOFTWARE\Oracle',
                data:   'C:\\Program Files\\Oracle\\Inventory',
                )
    }

    it  { should contain_file('C:/temp/wls_12c.rsp').with(
                ensure:    'present',
                content:   "[ENGINE]\nResponse File Version=1.0.0.0.0\n[GENERIC]\n\n#The oracle home location. This can be an existing Oracle Home or a new Oracle Home\nORACLE_HOME=C:/oracle/middleware\n#Set this variable value to the Installation Type selected. e.g. WebLogic Server, Coherence, Complete with Examples.\nINSTALL_TYPE=Fusion Middleware Infrastructure\n\n#Provide the My Oracle Support Username. If you wish to ignore Oracle Configuration Manager configuration provide empty string for user name.\nMYORACLESUPPORT_USERNAME=\n#Provide the My Oracle Support Password\nMYORACLESUPPORT_PASSWORD=<SECURE VALUE>\n#Set this to true if you wish to decline the security updates. Setting this to true and providing empty string for My Oracle Support username will ignore the Oracle Configuration Manager configuration\nDECLINE_SECURITY_UPDATES=true\n#Set this to true if My Oracle Support Password is specified\nSECURITY_UPDATES_VIA_MYORACLESUPPORT=false\n",
                )
    }

    it  { should contain_exec('Install WLS').with(
                command:   "c:\\java\\jdk1.7.0_75\\bin\\java.exe -Xmx1024m -Djava.io.tmpdir=C:/temp -jar c:\\software\\wls1036_generic.jar -silent -responseFile C:/temp/wls_12c.rsp",
                creates:   "C:/oracle/middleware/oracle_common",
                ).that_requires('File[C:/temp/wls_12c.rsp]').that_requires('Registry::Value[inst_loc]')
    }


  end

  describe 'With attributes 10.3.6,  on Windows platform' do
    let :pre_condition do
      'class { "fmw_jdk::install":
         java_home_dir   => "c:\\java\\jdk1.7.0_75",
         source_file     => "c:\\software\\jdk-7u75-windows-x64.exe",
       } 
       class { "fmw_wls":
         version             => "10.3.6",
         middleware_home_dir => "C:/oracle/middleware_11g",
       }
       '
    end
    let(:facts) {{ operatingsystem:           'windows',
                   kernel:                    'windows',
                   osfamily:                  'windows'}}
    let(:params){{
                  :java_home_dir       => 'c:\\java\\jdk1.7.0_75',
                  :source_file         => 'c:\\software\\wls1036_generic.jar',
                  :install_type        => 'wls',
                }}

    it  { should contain_registry__value('inst_loc').with(
                key:    'HKLM\SOFTWARE\Oracle',
                data:   'C:\\Program Files\\Oracle\\Inventory',
                )
    }

    it  { should contain_file('C:/temp/wls_11g.rsp').with(
                ensure:    'present',
                content:   "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<bea-installer>\n  <input-fields>\n    <data-value name=\"BEAHOME\" value=\"C:/oracle/middleware_11g\" />\n  </input-fields>\n</bea-installer>\n",
                )
    }

    it  { should contain_exec('Install WLS').with(
                command:   "c:\\java\\jdk1.7.0_75\\bin\\java.exe -Xmx1024m -Djava.io.tmpdir=C:/temp -Duser.country=US -Duser.language=en -jar c:\\software\\wls1036_generic.jar -mode=silent -silent_xml=C:/temp/wls_11g.rsp -log=C:/temp/wls.log -log_priority=info",
                creates:   "C:/oracle/middleware_11g/modules",
                ).that_requires('File[C:/temp/wls_11g.rsp]').that_requires('Registry::Value[inst_loc]')
    }


  end

end
