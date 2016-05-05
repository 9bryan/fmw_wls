#
# fmw_wls::internal::wls_windows
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_wls::internal::wls_windows(
  $java_home_dir = undef,
  $source_file   = undef,
  $install_type  = undef,
)
{
  registry::value { 'inst_loc':
    key  => 'HKLM\SOFTWARE\Oracle',
    data => $fmw_wls::ora_inventory_dir,
  }

  if ( $fmw_wls::version in ['12.2.1', '12.1.3', '12.1.2'] ){
    $wls_template = 'wls_12c.rsp'
  } elsif ( $fmw_wls::version in ['10.3.6', '12.1.1'] ){
    $wls_template = 'wls_11g.rsp'
  }

  if ( $install_type == 'wls' ){
    $wls_install_type = 'WebLogic Server'
  } elsif ( $install_type == 'infra' ) {
    $wls_install_type = 'Fusion Middleware Infrastructure'
  } else {
    $wls_install_type = 'WebLogic Server'
  }

  # add the webLogic silent response
  file { "${fmw_wls::tmp_dir}/${wls_template}":
    ensure  => present,
    content => template("fmw_wls/${wls_template}"),
  }

  if ( $fmw_wls::version in ['10.3.6', '12.1.1'] ) {
    exec{ 'Install WLS':
      command     => "${java_home_dir}\\bin\\java.exe -Xmx1024m -Djava.io.tmpdir=${fmw_wls::tmp_dir} -Duser.country=US -Duser.language=en -jar ${source_file} -mode=silent -silent_xml=${fmw_wls::tmp_dir}/${wls_template} -log=${fmw_wls::tmp_dir}/wls.log -log_priority=info",
      environment => ['JAVA_VENDOR=Sun', "JAVA_HOME=${java_home_dir}"],
      creates     => "${fmw_wls::middleware_home_dir}/modules",
      timeout     => 0,
      require     => [File["${fmw_wls::tmp_dir}/${wls_template}"],Registry::Value['inst_loc'],],
    }
  } elsif ( $fmw_wls::version in ['12.2.1', '12.1.3', '12.1.2'] ){
    exec{ 'Install WLS':
      command => "${java_home_dir}\\bin\\java.exe -Xmx1024m -Djava.io.tmpdir=${fmw_wls::tmp_dir} -jar ${source_file} -silent -responseFile ${fmw_wls::tmp_dir}/${wls_template}",
      creates => "${fmw_wls::middleware_home_dir}/oracle_common",
      timeout => 0,
      require => [File["${fmw_wls::tmp_dir}/${wls_template}"],Registry::Value['inst_loc'],],
    }
  }

}