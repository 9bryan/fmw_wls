#
# fmw_wls::setup
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_wls::setup()
{
  require fmw_wls

  unless $::kernel in ['Linux', 'SunOS'] {
    fail('Unrecognized operating system, use this class on a Linux or Solaris host')
  }

  group { $fmw_wls::os_group :
    ensure => present,
  }

  user { $fmw_wls::os_user :
    ensure     => present,
    uid        => $fmw_wls::os_user_uid,
    gid        => $fmw_wls::os_group,
    # groups     => $fmw_wls::os_group,
    shell      => $fmw_wls::os_shell,
    home       => "${fmw_wls::user_home_dir}/${fmw_wls::os_user}",
    comment    => 'created by puppet for WebLogic installation',
    require    => Group[$fmw_wls::os_group],
    managehome => true,
  }

}
