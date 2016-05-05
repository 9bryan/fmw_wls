#
# fmw_wls
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_wls(
  $version             = $fmw_wls::params::version,
  $middleware_home_dir = $fmw_wls::params::middleware_home_dir,
  $ora_inventory_dir   = $fmw_wls::params::ora_inventory_dir,
  $orainst_dir         = $fmw_wls::params::orainst_dir,
  $os_user             = $fmw_wls::params::os_user,
  $os_user_uid         = $fmw_wls::params::os_user_uid,
  $os_group            = $fmw_wls::params::os_group,
  $os_shell            = $fmw_wls::params::os_shell,
  $user_home_dir       = $fmw_wls::params::user_home_dir,
  $tmp_dir             = $fmw_wls::params::tmp_dir,
) inherits fmw_wls::params {
}