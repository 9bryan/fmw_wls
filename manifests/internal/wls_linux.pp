#
# fmw_wls::internal::wls_linux
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_wls::internal::wls_linux(
  $java_home_dir = undef,
  $source_file   = undef,
  $install_type  = undef,
)
{
  # add oraInst.loc to /etc for the oracle inventory location
  file { "${fmw_wls::orainst_dir}/oraInst.loc":
    ensure  => present,
    content => template('fmw_wls/oraInst.loc'),
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }

  # create the oracle inventory location under the WebLogic OS user
  file { $fmw_wls::ora_inventory_dir:
    ensure => directory,
    mode   => '0775',
    owner  => $fmw_wls::os_user,
    group  => $fmw_wls::os_group,
  }

  $middleware_home_parent_dir = fmw_wls_parent_folder($fmw_wls::middleware_home_dir)

  # make sure the middleware parent directory exists
  file { $middleware_home_parent_dir:
    ensure => directory,
    mode   => '0775',
    owner  => $fmw_wls::os_user,
    group  => $fmw_wls::os_group,
  }

  # make sure the middleware parent directory exists
  file { $fmw_wls::middleware_home_dir:
    ensure  => directory,
    mode    => '0775',
    owner   => $fmw_wls::os_user,
    group   => $fmw_wls::os_group,
    require => File[$middleware_home_parent_dir]
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
    mode    => '0755',
    owner   => $fmw_wls::os_user,
    group   => $fmw_wls::os_group,
  }

  if ( $fmw_wls::version in ['10.3.6', '12.1.1'] ) {
    exec{ 'Install WLS':
      command     => "${java_home_dir}/bin/java -Xmx1024m -Djava.io.tmpdir=${fmw_wls::tmp_dir} -Duser.country=US -Duser.language=en -jar ${source_file} -mode=silent -silent_xml=${fmw_wls::tmp_dir}/${wls_template} -log=${fmw_wls::tmp_dir}/wls.log -log_priority=info",
      environment => ['JAVA_VENDOR=Sun', "JAVA_HOME=${java_home_dir}"],
      creates     => "${fmw_wls::middleware_home_dir}/modules",
      user        => $fmw_wls::os_user,
      group       => $fmw_wls::os_group,
      cwd         => $fmw_wls::tmp_dir,
      timeout     => 0,
      require     => File["${fmw_wls::tmp_dir}/${wls_template}",
                          $fmw_wls::middleware_home_dir,
                          $middleware_home_parent_dir,
                          $fmw_wls::ora_inventory_dir,
                          "${fmw_wls::orainst_dir}/oraInst.loc"],
    }
  } elsif ( $fmw_wls::version in ['12.2.1', '12.1.3', '12.1.2'] ){
    exec{ 'Install WLS':
      command => "${java_home_dir}/bin/java -Xmx1024m -Djava.io.tmpdir=${fmw_wls::tmp_dir} -jar ${source_file} -silent -responseFile ${fmw_wls::tmp_dir}/${wls_template} -invPtrLoc ${fmw_wls::orainst_dir}/oraInst.loc",
      creates => "${fmw_wls::middleware_home_dir}/oracle_common",
      user    => $fmw_wls::os_user,
      group   => $fmw_wls::os_group,
      cwd     => $fmw_wls::tmp_dir,
      timeout => 0,
      require => File["${fmw_wls::tmp_dir}/${wls_template}",
                      $fmw_wls::middleware_home_dir,
                      $middleware_home_parent_dir,
                      $fmw_wls::ora_inventory_dir,
                      "${fmw_wls::orainst_dir}/oraInst.loc"],
    }
  }
}
